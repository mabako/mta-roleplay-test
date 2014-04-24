_c=createObject

function createObject(m,x,y,z,a,b,c,i,d)
	local t=_c(m,x,y,z,a,b,c)
	if d then
		setElementDimension(t,d)
	end
	if i then
		setElementInterior(t,i)
	end
	return t
end
