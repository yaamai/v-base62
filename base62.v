module base62

// vlang can't declare map in global context (currently?)
enum Base {
	base36
	base62
}
const encode_chars_defs = [
	"0123456789abcdefghijklmnopqrstuvwxyz",
	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
]
// (new TextEncoder).encode(bbbb); out = Array(80).fill(0); chars.forEach((e,idx) => out[idx] = e)
const decode_chars_defs = [
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,0,0,0,0,0,0,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,0,0,0,0,0],
]
const base_defs = [
	36,
	62
]

pub fn encode_base(data []byte, base_type Base) string {
	base := base_defs[int(base_type)]
	chars := encode_chars_defs[int(base_type)]

	mut buf := []byte{len: int(f64(data.len)*1.5)}
	mut last_pos := 0
	for d in data {
		mut calc := int(d)
		mut idx := buf.len-1
		for ; calc != 0 || last_pos < idx; idx-- {
			calc = calc + 256*buf[idx]
			buf[idx] = byte(calc % base)
			calc /= base
		}
		last_pos = idx
	}
	mut first_non_zero := 0
	for byt in buf {
		if byt != 0 {
			break
		}
		first_non_zero ++
	}

	return buf[first_non_zero..].map(chars[it]).bytestr()
}

pub fn decode_base(data string, base_type Base, output_length int) []byte {
	base := base_defs[int(base_type)]
	chars := decode_chars_defs[int(base_type)]

	mut buflen := output_length
	if output_length == -1 {
		buflen = int(f64(data.len))
	}

	mut buf := []byte{len: buflen}
	mut last_pos := 0
	for d in data {
		mut calc := chars[d]
		mut idx := buf.len-1
		for ; (calc != 0 || last_pos < idx) && idx >= 0; idx-- {
			calc = calc + base*buf[idx]
			buf[idx] = byte(calc % 256)
			calc /= 256
		}
		last_pos = idx
	}
	if output_length != -1 {
		return buf
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