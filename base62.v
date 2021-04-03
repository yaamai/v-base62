module base62

const base62_chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
pub fn encode(data []byte) string {
	// data[0]:
	//   buf[0] = data[0] mod 62
	//   buf[1] = data[0]/62 mod 62
	// data[1]:
	//   buf[0] = ((256*buf[0])+data[1]) mod 62
	//          = (256*buf[0] mod 62 + data[1] mod 62 ) mod 62
	//          = ((256 mod 62 * buf[0] mod 62) mod 62) + data[1] mod 62 ) mod 62
	//          = ((256 mod 62 * data[0] mod 62 mod 62) mod 62) + data[1] mod 62 ) mod 62
	//          = ((256 mod 62 * data[0] mod 62) mod 62) + data[1] mod 62 ) mod 62
	//          = (256*data[0] mod 62) + data[1] mod 62 ) mod 62
	//          = (256*data[0]+ data[1]) mod 62
	//          = (data[0] * 256^1 + data[1] * 256^0) mod 62
	mut buf := []byte{len: int(f64(data.len)*1.5)}
	mut last_pos := 0
	for d in data {
		mut calc := int(d)
		mut idx := buf.len-1
		for ; calc != 0 || last_pos < idx; idx-- {
			calc = calc + 256*buf[idx]
			buf[idx] = byte(calc % 62)
			calc /= 62
		}
		last_pos = idx
	}
	mut first_non_zero := 0
	for b in buf {
		if b != 0 {
			break
		}
		first_non_zero ++
	}

	return buf[first_non_zero..].map(base62_chars[it]).bytestr()
}

fn base62_chars_index(ch rune) ?int {
	if ch >= `0` && ch <= `9` {
		return int(ch - `0`)
	} else if ch >= `A` && ch <= `Z` {
		return int(ch - `A` + 10)
	} else if ch >= `a` && ch <= `z` {
		return int(ch - `a` + 10 + 26)
	}
	return error("invalid base62 char")
}

pub fn decode(data string) []byte {
	mut buf := []byte{len: int(f64(data.len))}
	mut last_pos := 0
	for d in data {
		mut calc := base62_chars_index(d) or { continue }
		mut idx := buf.len-1
		for ; calc != 0 || last_pos < idx; idx-- {
			calc = calc + 62*buf[idx]
			buf[idx] = byte(calc % 256)
			calc /= 256
		}
		last_pos = idx
	}
	mut first_non_zero := 0
	for b in buf {
		if b != 0 {
			break
		}
		first_non_zero ++
	}

	return buf[first_non_zero..]
}