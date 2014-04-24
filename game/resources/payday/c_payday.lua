function cPayDay(faction, pay, profit, interest, donatormoney, tax, incomeTax, vtax, ptax, rent, grossincome)
	-- output payslip
	outputChatBox("-------------------------- PAY SLIP --------------------------", 255, 194, 14)
		
	-- state earnings/money from faction
	if not (faction) then
		if (pay + tax > 0) then
			outputChatBox("    State Benefits: #00FF00$" .. exports.global:formatMoney(pay+tax), 255, 194, 14, true)
		end
	else
		if (pay + tax > 0) then
			outputChatBox("    Wage Paid: #00FF00$" .. exports.global:formatMoney(pay+tax), 255, 194, 14, true)
		end
	end
	
	-- business profit
	if (profit > 0) then
		outputChatBox("    Business Profit: #00FF00$" .. exports.global:formatMoney(profit), 255, 194, 14, true)
	end
	
	-- bank interest
	if (interest > 0) then
		outputChatBox("    Bank Interest: #00FF00$" .. exports.global:formatMoney(interest) .. " (0.4%)",255, 194, 14, true)
	end
	
	-- donator money (nonRP)
	if (donatormoney > 0) then
		outputChatBox("    Donator Money: #00FF00$" .. exports.global:formatMoney(donatormoney), 255, 194, 14, true)
	end
	
	-- Above all the + stuff
	-- Now the - stuff below
	
	-- income tax
	if (tax > 0) then
		outputChatBox("    Income Tax of " .. (incomeTax*100) .. "%: #FF0000$" .. exports.global:formatMoney(tax), 255, 194, 14, true)
	end
	
	if (vtax > 0) then
		outputChatBox("    Vehicle Tax: #FF0000$" .. exports.global:formatMoney(vtax), 255, 194, 14, true)
	end
	
	if (ptax > 0) then
		outputChatBox("    Property Expenses: #FF0000$" .. exports.global:formatMoney(ptax), 255, 194, 14, true )
	end
	
	if (rent > 0) then
		outputChatBox("    Appartment Rent: #FF0000$" .. exports.global:formatMoney(rent), 255, 194, 14, true)
	end
	
	outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	
	if grossincome == 0 then
		outputChatBox("  Gross Income: $0",255, 194, 14, true)
	elseif (grossincome > 0) then
		outputChatBox("  Gross Income: #00FF00$" .. exports.global:formatMoney(grossincome),255, 194, 14, true)
		outputChatBox("  Remark(s): Transfered to your bank account.", 255, 194, 14)
	else
		outputChatBox("  Gross Income: #FF0000$" .. exports.global:formatMoney(grossincome), 255, 194, 14, true)
		outputChatBox("  Remark(s): Taking from your bank account.", 255, 194, 14)
	end
	
	
	if (pay + tax == 0) then
		if not (faction) then
			outputChatBox("    The government could not afford to pay you your state benefits.", 255, 0, 0)
		else
			outputChatBox("    Your employer could not afford to pay your wages.", 255, 0, 0)
		end
	end
	
	if (rent == -1) then
		outputChatBox("    You were evicted from your appartment, as you can't pay the rent any longer.", 255, 0, 0)
	end
	
	outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	-- end of output payslip
	
	triggerEvent("updateWaves", getLocalPlayer())
end
addEvent("cPayDay", true)
addEventHandler("cPayDay", getRootElement(), cPayDay)