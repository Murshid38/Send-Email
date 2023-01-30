pageextension 50100 SalesOrder extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Print")
        {
            action("Send Email")
            {
                ApplicationArea = All;
                Image = SendMail;
                ToolTip = 'Send email for the customer about the sales order.';

                trigger OnAction()
                begin
                    SendEmail();
                end;
            }
        }

    }

    local procedure SendEmail()
    var
        SalesLine: Record "Sales Line";
        EmailMessage: Codeunit "Email Message";
        EmailSend: Codeunit Email;
        BodyMessage: Text;
        Recipient: Text;
        CustomerName: Text;
        SalesOrderNo: Text;
        LineNo: Text;
        Description: Text;
        Quantity: Text;
        UnitPrice: Text;
        Total: Text;
    begin
        Clear(BodyMessage);

        // Recipient := Rec."Sell-to E-Mail";
        Recipient := 'murshidmohamed38@gmail.com';
        CustomerName := Rec."Sell-to Customer Name";
        SalesOrderNo := Rec."No.";

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", Rec."No.");

        BodyMessage := 'Dear ' + CustomerName + ',<br><br>You have successfully places Sales Order No ' + SalesOrderNo + '<br><br><table style="font-family: Arial, Helvetica, sans-serif;border-style:1px solid #00838F;width: 70%;"><tr style="padding-top: 12px;padding-bottom: 12px;text-align: left;background-color: #00838F;color: white;"><th>LineNo</th><th>Description</th><th>Quanity</th><th>Unit Cost</th><th>Total</th></tr>';

        if SalesLine.FindSet() then
            //changed the FindFirst() to FindSet() refer why?
            repeat
                LineNo := Format(SalesLine."Line No.");
                Description := Format(SalesLine.Description);
                Quantity := Format(SalesLine.Quantity);
                UnitPrice := Format(SalesLine."Unit Price");
                Total := Format(SalesLine.Amount);

                BodyMessage += '<tr style="background-color: #D9F0F2"><td>' + LineNo + '</td><td>' + Description + '</td><td>' + Quantity + '</td><td>' + UnitPrice + '</td><td>' + Total + '</td></tr>';
            until SalesLine.Next() = 0;

        BodyMessage += '</table><br><br><b>Thank you & Regards</b><br>This is a System genarated Message';

        EmailMessage.Create(Recipient, 'Testing Email Subject', BodyMessage, true);
        if EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Message('Email sent successfully!');
    end;
}