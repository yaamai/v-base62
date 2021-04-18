module base

fn test_base62_encode() {
	assert encode([byte(100), 100]) == "6gW"
	assert encode([byte(0x3A), 0xDE, 0x68, 0xB1]) == "14q60P"
	assert encode([byte(`9`), `8`, `7`, `6`, `5`, `4`, `3`, `2`, `1`]) == "KHc6iHtXW3iD"
	assert encode([byte(116), 32, 8, 99, 100, 232, 4, 7]) == "9y88pxSoliJ"
}

fn test_base62_decode() {
	assert decode("6gW") == [byte(100), 100]
	assert decode("14q60P") == [byte(0x3A), 0xDE, 0x68, 0xB1]
	assert decode("KHc6iHtXW3iD") == [byte(`9`), `8`, `7`, `6`, `5`, `4`, `3`, `2`, `1`]
	assert decode("9y88pxSoliJ") == [byte(116), 32, 8, 99, 100, 232, 4, 7]
}
