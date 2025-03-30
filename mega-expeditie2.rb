def encode n
	sprintf '%05b', n
end

def crc b
	b.count('1').even? ? '01' : '10'
end

def barcode_black n
	q, r = n.divmod 32
	b = encode(q + 3) + encode(r)
	(b + crc(b) + '1').reverse!
end

def neg_char c
	c == '0' ? '1' : '0'
end

def barcode_white b
	w = ''
	b[1..].each_char do |c|
		w += neg_char c
	end
	w + '0'
end

def print_black b
	print '<font class="bar">'
	print '&block;'
	print '&block;' if b == '1'
	print '</font>'
end

def print_white w
	print '<font class="spc">'
	print '&nbsp;&nbsp;&nbsp;'
	print '&nbsp;&nbsp;&nbsp;' if w == '1'
	print '</font>'
end

def barcode n
	b = barcode_black n
	w = barcode_white b
	6.times do
		13.times do |i|
			print_black b[i]
			print_white w[i]
		end
		print "<br/>\n"
	end
	print n
end

print "<html><head><style>\n"
print ".bar { font-size:8.8px }\n"
print ".spc { font-size:8.3px }\n"
print "</style></head><body><br/><br/>\n"
print "<table width='100%'>\n"
(1..96).step(2) do |n|
	print "<tr height='110px'><td width='50px'>&nbsp;</td><td>"
	barcode n
	print '</td><td>'
	barcode n + 1
	print "</td></tr>\n"
	print "</table><br/><br/><br/><br/><br/><table width='100%'>\n" if [17, 35, 53, 71, 89].include? n
end
print "</table></body></html>\n"