temp=nil
_c=createObject

function createObject(m,x,y,z,a,b,c,i,d,e)
	local t=_c(m,x,y,z,a,b,c)
	if d then
		setElementDimension(t,d)
	end
	if i then
		setElementInterior(t,i)
	end
	if e then
		setElementAlpha(t,e)
	end
	return t
end
