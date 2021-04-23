module base

fn test_base62_encode() {
	assert encode_base([byte(100), 100], Base.base62) == "6gW"
	assert encode_base([byte(0x3A), 0xDE, 0x68, 0xB1], Base.base62) == "14q60P"
	assert encode_base([byte(`9`), `8`, `7`, `6`, `5`, `4`, `3`, `2`, `1`], Base.base62) == "KHc6iHtXW3iD"
	assert encode_base([byte(116), 32, 8, 99, 100, 232, 4, 7], Base.base62) == "9y88pxSoliJ"
}

fn test_base62_decode() {
	assert decode_base("6gW", Base.base62, 2) == [byte(100), 100]
	assert decode_base("14q60P", Base.base62, 4) == [byte(0x3A), 0xDE, 0x68, 0xB1]
	assert decode_base("KHc6iHtXW3iD", Base.base62, 9) == [byte(`9`), `8`, `7`, `6`, `5`, `4`, `3`, `2`, `1`]
	assert decode_base("9y88pxSoliJ", Base.base62, 8) == [byte(116), 32, 8, 99, 100, 232, 4, 7]
}
