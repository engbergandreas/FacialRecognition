function img = normalizeimg(input)
maxvalue = max(max(input));
minvalue = min(min(input));

img = (input - minvalue) / (maxvalue - minvalue);
end