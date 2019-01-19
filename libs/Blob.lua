local Blob = {
	_VERSION     = 'Blob 1.3.3',
	_LICENSE     = 'MIT, https://opensource.org/licenses/MIT',
	_URL         = 'https://github.com/megagrump/blob',
	_DESCRIPTION = 'Binary serialization and parsing for LuaJIT',
}

local ffi = require('ffi')
local band, bnot, shr = bit.band, bit.bnot, bit.rshift
local _native, _endian, _parseEndian
local _tags, _getTag, _taggedReaders, _taggedWriters, _packMap, _unpackMap

--- ### `Blob(data, size, options)`
---
--- Creates a new Blob instance.
---
--- * `data` (nil) A Lua string with which to populate the blob, or a cdata array to use as buffer
--- * `size` (length of data, or 1024 when data is nil) The initial size of the blob. Will grow automatically when needed
--- * `options` (nil) Blob options
---
--- Available options:
--- * `source_endianess`: the byte order of the source data (see below)
--- * `target_endianess`: the byte order written data will be saved in (see below)
---
--- Endian options: use `le` or `<` for little endian; `be` or `>` for big endian; `native`, `=` or `nil` to use the
--- host's native endianess (default)
---
--- #### Returns
---
--- a new Blob object
function Blob:init(data, size, options)
	options = options or {}

	self:setSourceEndian(options.source_endianess)
	self:setTargetEndian(options.target_endianess)

	self._length = 0

	if not data then
		self:_allocate(size or 1024)
	else
		local datatype = type(data)
		if datatype == 'string' then
			self:_allocate(math.max(size or #data, #data))
			self._length = #data
			ffi.copy(self._data, data, #data)
		elseif datatype == 'cdata' then
			size = size or ffi.sizeof(data)
			assert(size and size > 0, "Invalid or unknown size of cdata object")
			self._size, self._length, self._data = size, size, data
		else
			error("Invalid data type <" .. datatype .. ">")
		end
	end

	self._readPtr = 0

	return self
end

--- ### `Blob:setSourceEndian(endian)`
---
--- Set source data byte order. All `read*` functions will assume the source data to be in this byte order.
---
--- * `endian` (nil) Byte order.
--- Can be either `le` or `<` for little endian, `be` or `>` for big endian, or `native` or `nil` for native host byte
--- order.
---
--- #### Returns
---
--- a reference to the current blob
function Blob:setSourceEndian(endian)
	self._endian_in = _endian[_parseEndian(endian)]._in

	return self
end

--- ### `Blob:setTargetEndian(endian)`
---
--- Set target byte order. All `write*` functions will write data in this byte order.
---
--- * `endian` (nil) Byte order.
--- Can be either `le` or `<` for little endian, `be` or `>` for big endian, or `native` or `nil` for native host byte
--- order.
---
--- #### Returns
---
--- a reference to the current blob
function Blob:setTargetEndian(endian)
	self._endian_out = _endian[_parseEndian(endian)]._out

	return self
end

--- ### `Blob:read()`
---
--- Reads a string, a number, a boolean or a table from the input buffer.
--- The data must have been written by `Blob:write()`.
--- The type of the value is automatically detected from the input metadata.
---
--- #### Returns
---
--- the value read from the input buffer
function Blob:read()
	local tag, value = self:_readTagged()
	return value
end

--- ### `Blob:readNumber()`
---
--- Reads a Lua number from the input buffer.
---
--- #### Returns
---
--- the number read read from the input buffer
function Blob:readNumber()
	_native.u32[0], _native.u32[1] = self:readU32(), self:readU32()
	return _native.n
end

--- ### `Blob:readString()`
---
--- Reads a string from the input buffer.
--- The string must have been written by `Blob:write()` or `Blob:writeString()`.
---
--- #### Returns
---
--- the string read from the input buffer
function Blob:readString()
	local len, ptr = self:readVarU32(), self._readPtr
	assert(ptr + len - 1 < self._length, "Out of data")
	self._readPtr = ptr + len
	return ffi.string(ffi.cast('uint8_t*', self._data + ptr), len)
end

--- ### `Blob:readBool()`
---
--- Reads a boolean value from the input buffer.
---
--- The data is expected to be 8 bits long, `0 == false`, any other value == `true`
---
--- #### Returns
---
--- the boolean value read from the input buffer
function Blob:readBool()
	return self:readU8() ~= 0
end

--- ### `Blob:readTable()`
---
--- Reads a Lua table from the input buffer.
---
--- The table must have been written with `Blob:write()` or `Blob:writeTable()`.
---
--- #### Returns
---
--- the table read from the input buffer
function Blob:readTable()
	local result = {}
	local tag, key = self:_readTagged()
	while tag ~= _tags.stop do
		tag, result[key] = self:_readTagged()
		tag, key = self:_readTagged()
	end
	return result
end

--- ### `Blob:readU8()`
---
--- Reads one unsigned 8 bit value from the input buffer.
---
--- #### Returns
---
--- the unsigned 8 bit value read from the input buffer
function Blob:readU8()
	assert(self._readPtr < self._length, "Out of data")
	local u8 = self._data[self._readPtr]
	self._readPtr = self._readPtr + 1
	return u8
end

--- ### `Blob:readS8()`
---
--- Reads one signed 8 bit value from the input buffer.
---
--- #### Returns
---
--- the signed 8 bit value read from the input buffer
function Blob:readS8()
	_native.u8[0] = self:readU8()
	return _native.s8[0]
end

--- ### `Blob:readU16()`
---
--- Reads one unsigned 16 bit value from the input buffer.
---
--- #### Returns
---
--- the unsigned 16 bit value read from the input buffer
function Blob:readU16()
	local ptr = self._readPtr
	assert(ptr + 1 < self._length, "Out of data")
	self._readPtr = ptr + 2
	return self._endian_in._16(self._data[ptr], self._data[ptr + 1])
end

--- ### `Blob:readS16()`
---
--- Reads one signed 16 bit value from the input buffer.
---
--- #### Returns
---
--- the signed 16 bit value read from the input buffer
function Blob:readS16()
	_native.u16[0] = self:readU16()
	return _native.s16[0]
end

--- ### `Blob:readU32()`
---
--- Reads one unsigned 32 bit value from the input buffer.
---
--- #### Returns
---
--- the unsigned 32 bit value read from the input buffer
function Blob:readU32()
	local ptr = self._readPtr
	assert(ptr + 3 < self._length, "Out of data")
	self._readPtr = ptr + 4
	return self._endian_in._32(self._data[ptr], self._data[ptr + 1], self._data[ptr + 2], self._data[ptr + 3])
end

--- ### `Blob:readS32()`
---
--- Reads one signed 32 bit value from the input buffer.
---
--- #### Returns
---
--- the signed 32 bit value read from the input buffer
function Blob:readS32()
	_native.u32[0] = self:readU32()
	return _native.s32[0]
end

--- ### `Blob:readU64()`
---
--- Reads one unsigned 64 bit value from the input buffer.
---
--- #### Returns
---
--- the unsigned 64 bit value read from the input buffer
function Blob:readU64()
	local ptr = self._readPtr
	assert(ptr + 7 < self._length, "Out of data")
	self._readPtr = ptr + 8
	return self._endian_in._64(self._data[ptr], self._data[ptr + 1], self._data[ptr + 2], self._data[ptr + 3],
		self._data[ptr + 4], self._data[ptr + 5], self._data[ptr + 6], self._data[ptr + 7])
end

--- ### `Blob:readS64()`
---
--- Reads one signed 64 bit value from the input buffer.
---
--- #### Returns
---
--- the signed 64 bit value read from the input buffer
function Blob:readS64()
	_native.u64 = self:readU64()
	return _native.s64
end

--- ### `Blob:readFloat()`
---
--- Reads one 32 bit floating point value from the input buffer.
---
--- #### Returns
---
--- the 32 bit floating point value read from the input buffer
function Blob:readFloat()
	_native.u32[0] = self:readU32()
	return _native.f[0]
end

--- ### `Blob:readVarU32()`
---
--- Reads a variable length 32 bit integer value from the input buffer.
--- See `Blob:writeVarU32`.
---
--- #### Returns
---
--- the unsigned 32 bit integer value read from the input buffer
function Blob:readVarU32()
	local result = self:readU8()
	if band(result, 0x00000080) == 0 then return result end
	result = band(result, 0x0000007f) + self:readU8() * 2 ^ 7
	if band(result, 0x00004000) == 0 then return result end
	result = band(result, 0x00003fff) + self:readU8() * 2 ^ 14
	if band(result, 0x00200000) == 0 then return result end
	result = band(result, 0x001fffff) + self:readU8() * 2 ^ 21
	if band(result, 0x10000000) == 0 then return result end
	return band(result, 0x0fffffff) + self:readU8() * 2 ^ 28
end

--- ### `Blob:readRaw(len)`
---
--- Reads raw binary data from the input buffer.
---
--- * `len` the length of the data (in bytes) to read
---
--- #### Returns
---
--- a string with raw data
function Blob:readRaw(len)
	local ptr = self._readPtr
	assert(ptr + len - 1 < self._length, "Out of data")
	self._readPtr = ptr + len
	return ffi.string(ffi.cast('uint8_t*', self._data + ptr), len)
end

--- ### `Blob:skip(len)`
---
--- Skips a number of bytes in the input buffer.
---
--- * `len` the number of bytes to skip
---
--- #### Returns
---
--- a reference to the current blob
function Blob:skip(len)
	assert(self._readPtr + len - 1 < self._length, "Out of data")
	self._readPtr = self._readPtr + len
	return self
end

--- ### `Blob:readCString()`
---
--- Reads a zero-terminated string from the input buffer (up to 2 ^ 32 - 1 bytes).
---
--- Keeps reading bytes until a null byte is encountered.
---
--- #### Returns
---
--- the string read from the input buffer
function Blob:readCString()
	local start = self._readPtr
	while self:readU8() > 0 do end
	local len = self._readPtr - start
	assert(len < 2 ^ 32, "String too long")

	return ffi.string(ffi.cast('uint8_t*', self._data + start), len - 1)
end

-----------------------------------------------------------------------------

--- ### `Blob:unpack(format)`
---
--- Parses the current input buffer into separate values according to a format string.
---
--- The format string syntax is based on the format that Lua 5.3's string.unpack accepts, but does not implement all
--- features and uses fixed instead of native data sizes.
--- See http://www.lua.org/manual/5.3/manual.html#6.4.2 for details.
---
--- * `format` data format descriptor string
---
--- Supported format specifiers:
--- * Endianess: `<` (little), `>` (big), `=` (native, default). Endianess can be switched any number of times in a format string.
--- * Integer types: `b`,`B` (8 bits) / `h`,`H` (16 bits) / `l`,`L` (32 bits) / `V` (variable length unsigned 32 bits) / `q`,`Q` (64 bits)
--- * Floating point types: `f` (32 bits) `d`,`n` (64 bits)
--- * String types: `z` (zero terminated), `s` (preceding length bytes)
--- * Raw data: `c[length]` (up to 2 ^ 32 - 1 bytes),
--- * Boolean: `y`
--- * Table: `t`
--- * ` ` (a single space character): skip one byte
---
--- #### Returns
---
--- all values parsed from the input buffer
function Blob:unpack(format)
	assert(type(format) == 'string', "Invalid format specifier")
	local result, len = {}, nil

	local function _readRaw()
		local l = tonumber(table.concat(len))
		assert(l, l or "Invalid string length specification: " .. table.concat(len))
		assert(l < 2 ^ 32, "Maximum string length exceeded")
		table.insert(result, self:readRaw(l))
		len = nil
	end

	format:gsub('.', function(c)
		if len then
			if tonumber(c) then
				table.insert(len, c)
			else
				_readRaw()
			end
		end

		if not len then
			local parser = _unpackMap[c]
			assert(parser, parser or "Invalid data type specifier: " .. c)
			if c == 'c' then
				len = {}
			else
				local parsed = parser(self)
				if parsed ~= nil then
					table.insert(result, parsed)
				end
			end
		end
	end)

	if len then _readRaw() end -- final specifier in format was a length specifier

	return unpack(result)
end

--- ### `Blob:pack(format, ...)`
---
--- Puts data into the current input buffer according to a format string.
--- See Blob:unpack for a list of supported format specifiers.
---
--- * `format` data format descriptor string
--- * `...` values to write
---
--- #### Returns
---
--- a reference to the current blob
function Blob:pack(format, ...)
	assert(type(format) == 'string', "Invalid format specifier")
	local data, index, len = {...}, 1, nil
	local limit = select('#', ...)

	local function _writeRaw()
		local l = tonumber(table.concat(len))
		assert(l, l or "Invalid string length specification: " .. table.concat(len))
		assert(l < 2 ^ 32, "Maximum string length exceeded")
		self:writeRaw(data[index], l)
		index, len = index + 1, nil
	end

	format:gsub('.', function(c)
		if len then
			if tonumber(c) then
				table.insert(len, c)
			else
				assert(index <= limit, "Number of arguments to pack() does not match format specifiers")
				_writeRaw()
			end
		end

		if not len then
			local writer = _packMap[c]
			assert(writer, writer or "Invalid data type specifier: " .. c)
			if c == 'c' then
				len = {}
			else
				assert(index <= limit, "Number of arguments to pack() does not match format specifiers")
				if writer(self, data[index]) then
					index = index + 1
				end
			end
		end
	end)

	if len then _writeRaw() end -- final specifier in format was a length specifier

	return self
end

--- ### `Blob:write(value)`
---
--- Writes a value to the output buffer. Determines the type of the value automatically.
--- Supported value types are `number`, `string`, `boolean` and `table`.
---
--- * `value` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:write(value)
	return self:_writeTagged(value)
end

--- ### `Blob:writeNumber(value)`
---
--- Writes a Lua number to the output buffer.
---
--- * `number` the number to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeNumber(number)
	_native.n = number
	self:writeU32(_native.u32[0]):writeU32(_native.u32[1])
	return self
end

--- ### `Blob:writeBool(value)`
---
--- Writes a boolean value to the output buffer.
--- The value is written as an unsigned 8 bit value (`true = 1`, `false = 0`)
---
--- * `bool` the boolean value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeBool(bool)
	self:writeU8(bool and 1 or 0)
	return self
end

--- ### `Blob:writeString(str)`
---
--- Writes a string to the output buffer.
--- Stores the length of the string in a compact format before the actual string data.
---
--- * `str` the string to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeString(str)
	local length = #str
	local makeRoom = (self._size - self._length) - (length + self:sizeofVarU32(length))
	if makeRoom < 0 then
		self:_grow(math.abs(makeRoom))
	end
	self:writeVarU32(length)
	ffi.copy(ffi.cast('char*', self._data + self._length), str, length)
	self._length = self._length + length
	return self
end

--- ### `Blob:writeU8(u8)`
---
--- Writes an unsigned 8 bit value to the output buffer.
---
--- * `u8` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeU8(u8)
	if self._length + 1 > self._size then self:_grow(1) end
	self._data[self._length] = u8
	self._length = self._length + 1
	return self
end

--- ### `Blob:writeS8(s8)`
---
--- Writes a signed 8 bit value to the output buffer.
---
--- * `s8` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeS8(s8)
	_native.s8[0] = s8
	return self:writeU8(_native.u8[0])
end

--- ### `Blob:writeU16(u16)`
---
--- Writes an unsigned 16 bit value to the output buffer.
---
--- * `u16` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeU16(u16)
	local len = self._length
	if len + 2 > self._size then self:_grow(2) end
	local b1, b2 = self._endian_out._16(band(u16, 2 ^ 8 - 1), shr(u16, 8))
	self._data[len], self._data[len + 1] = b1, b2
	self._length = len + 2
	return self
end

--- ### `Blob:writeS16(s16)`
---
--- Writes a signed 16 bit value to the output buffer.
---
--- * `s16` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeS16(s16)
	_native.s16[0] = s16
	return self:writeU16(_native.u16[0])
end

--- ### `Blob:writeU32(u32)`
---
--- Writes an unsigned 32 bit value to the output buffer.
---
--- * `u32` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeU32(u32)
	local len = self._length
	if len + 4 > self._size then self:_grow(4) end
	local w1, w2 = self._endian_out._32(band(u32, 2 ^ 16 - 1), shr(u32, 16))
	local b1, b2 = self._endian_out._16(band(w1, 2 ^ 8 - 1), shr(w1, 8))
	local b3, b4 = self._endian_out._16(band(w2, 2 ^ 8 - 1), shr(w2, 8))
	self._data[len], self._data[len + 1], self._data[len + 2], self._data[len + 3] = b1, b2, b3, b4
	self._length = len + 4
	return self
end

--- ### `Blob:writeS32(s32)`
---
--- Writes a signed 32 bit value to the output buffer.
---
--- * `s32` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeS32(s32)
	_native.s32[0] = s32
	return self:writeU32(_native.u32[0])
end

--- ### `Blob:writeU64(u64)`
---
--- Writes an unsigned 64 bit value to the output buffer.
---
--- * `u64` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeU64(u64)
	_native.u64 = u64
	local a, b = self._endian_out._64(_native.u32[0], _native.u32[1])
	return self:writeU32(a):writeU32(b)
end

--- ### `Blob:writeS64(s64)`
---
--- Writes a signed 64 bit value to the output buffer.
---
--- * `s64` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeS64(s64)
	_native.s64 = s64
	local a, b = self._endian_out._64(_native.u32[0], _native.u32[1])
	return self:writeU32(a):writeU32(b)
end

--- ### `Blob:writeFloat(float)`
---
--- Writes a 32 bit floating point value to the output buffer.
---
--- * `float` the value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeFloat(float)
	_native.f[0] = float
	return self:writeU32(_native.u32[0])
end

--- ### `Blob:writeRaw(raw)`
---
--- Writes raw binary data to the output buffer.
---
--- * `raw` a string with the data to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeRaw(raw)
	local length = #raw
	local makeRoom = (self._size - self._length) - length
	if makeRoom < 0 then
		self:_grow(math.abs(makeRoom))
	end
	ffi.copy(ffi.cast('char*', self._data + self._length), raw, length)
	self._length = self._length + length
	return self
end

--- ### `Blob:writeCString(str)`
---
--- Writes a string to the output buffer, followed by a null byte.
---
--- * `str` the string to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeCString(str)
	self:writeRaw(str)
	self:writeU8(0)
	return self
end

--- ### `Blob:writeTable(table)`
---
--- Writes a table to the output buffer.
--- Supported field types are number, string, bool and table. Cyclic references throw an error.
---
--- * `table` the table to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeTable(t)
	return self:_writeTable(t, {})
end


--- ### `Blob:writeVarU32(value)`
---
--- Writes an unsigned 32 bit integer value with varying length.
--- The value is written in an encoded format where the length depends on the value: larger values need more space.
--- The minimum length is 1 byte for values < 2^7, maximum length is 5 bytes for values >= 2^28.
--- See also `Blob:sizeofVarU32`.
---
--- * `value` the unsigned integer value to write to the output buffer
---
--- #### Returns
---
--- a reference to the current blob
function Blob:writeVarU32(value)
	assert(value < 2 ^ 32, "Exceeded U32 value range")
	for i = 7, 28, 7 do
		local mask, shift = 2 ^ i - 1, i - 7
		if value < 2 ^ i then
			return self:writeU8(shr(band(value, mask), shift))
		else
			self:writeU8(shr(band(value, mask), shift) + 0x80)
		end
	end
	return self:writeU8(shr(band(value, 0xf0000000), 28))
end

-----------------------------------------------------------------------------

--- ### `Blob:string()`
---
--- Returns the current buffer contents as a string.
---
--- #### Returns
---
--- a string with the current buffer contents
function Blob:string()
	return ffi.string(self._data, self._length)
end

--- ### `Blob:length()`
---
--- Returns the number of bytes stored in the blob.
---
--- #### Returns
---
--- the number of bytes stored in the blob
function Blob:length()
	return self._length
end

--- ### `Blob:size()`
---
--- Returns the size of the write buffer in bytes
---
--- #### Returns
---
--- write buffer size in bytes
function Blob:size()
	return self._size
end

--- ### `Blob:rewind()`
---
--- Resets the read position to the beginning of the buffer.
---
--- #### Returns
---
--- a reference to the current blob
function Blob:rewind()
	self._readPtr = 0
	return self
end

--- ### `Blob:position()`
---
--- Returns the current read position as an offset from the start of the blob buffer in bytes.
---
--- #### Returns
---
--- current read position
function Blob:position()
	return self._readPtr
end

--- ### `Blob:sizeofVarU32(value)`
---
--- Returns the number of bytes required to store an unsigned 32 bit value when written by `Blob:writeVarU32`.
---
--- * `value` the unsigned 32 bit value to write
---
--- #### Returns
---
--- the number of bytes required by `Blob:writeVarU32` to store value
function Blob:sizeofVarU32(value)
	if value < 2 ^ 7 then return 1 end
	if value < 2 ^ 14 then return 2 end
	if value < 2 ^ 21 then return 3 end
	if value < 2 ^ 28 then return 4 end
	return 5
end

-----------------------------------------------------------------------------

function Blob:_allocate(size)
	local data
	if size > 0 then
		data = ffi.new('uint8_t[?]', size)
		if self._data then
			ffi.copy(data, self._data, self._length)
		end
	end
	self._data, self._size = data, size
	self._length = math.min(size, self._length)
end

function Blob:_grow(minimum)
	minimum = minimum or 0
	local newSize = math.max(self._size + minimum, math.floor(math.max(1, self._size * 1.5) + .5))
	self:_allocate(newSize)
end

function Blob:_readTagged()
	local tag = self:readU8()
	return tag, tag ~= _tags.stop and _taggedReaders[tag](self)
end

function Blob:_writeTable(t, stack)
	stack = stack or {}
	local ttype = type(t)
	assert(ttype == 'table', ttype == 'table' or string.format("Invalid type '%s' for Blob:writeTable", ttype))
	assert(not stack[t], "Cycle detected; can't serialize table")

	stack[t] = true
	for key, value in pairs(t) do
		self:_writeTagged(key, stack)
		self:_writeTagged(value, stack)
	end
	stack[t] = nil

	self:writeU8(_tags.stop)
	return self
end

function Blob:_writeTagged(value, stack)
	local tag = _getTag(value)
	assert(tag, tag or string.format("Can't write values of type '%s'", type(value)))
	self:writeU8(tag)
	return _taggedWriters[tag](self, value, stack)
end

function _parseEndian(endian)
	if not endian or endian == '=' or endian == 'native' then
		endian = ffi.abi('le') and 'le' or 'be'
	elseif endian == '<' then
		endian = 'le'
	elseif endian == '>' then
		endian = 'be'
	end
	local valid = endian == 'le' or endian == 'be'
	assert(valid, valid or "Invalid endianess identifier: " .. endian)

	return endian
end

function _getTag(value)
	if value == true or value == false then
		return _tags[value]
	end

	return _tags[type(value)]
end

_native = ffi.new[[
	union {
		  int8_t s8[8];
		 uint8_t u8[8];
		 int16_t s16[4];
		uint16_t u16[4];
		 int32_t s32[2];
		uint32_t u32[2];
		   float f[2];
		 int64_t s64;
		uint64_t u64;
		  double n;
	}
]]

_endian = {
	le = {
		_out = {
			_16 = function(b1, b2) return b1, b2 end,
			_32 = function(w1, w2) return w1, w2 end,
			_64 = function(d1, d2) return d1, d2 end,
		},

		_in = {
			_16 = function(b1, b2)
				_native.u8[0], _native.u8[1] = b1, b2
				return _native.u16[0]
			end,
			_32 = function(b1, b2, b3, b4)
				_native.u8[0], _native.u8[1], _native.u8[2], _native.u8[3] = b1, b2, b3, b4
				return _native.u32[0]
			end,
			_64 = function(b1, b2, b3, b4, b5, b6, b7, b8)
				_native.u8[0], _native.u8[1], _native.u8[2], _native.u8[3],
				_native.u8[4], _native.u8[5], _native.u8[6], _native.u8[7] = b1, b2, b3, b4, b5, b6, b7, b8
				return _native.u64
			end,
		}
	},

	be = {
		_out = {
			_16 = function(b1, b2) return b2, b1 end,
			_32 = function(w1, w2) return w2, w1 end,
			_64 = function(d1, d2) return d2, d1 end,
		},

		_in = {
			_16 = function(b1, b2)
				_native.u8[0], _native.u8[1] = b2, b1
				return _native.u16[0]
			end,
			_32 = function(b1, b2, b3, b4)
				_native.u8[0], _native.u8[1], _native.u8[2], _native.u8[3] = b4, b3, b2, b1
				return _native.u32[0]
			end,
			_64 = function(b1, b2, b3, b4, b5, b6, b7, b8)
				_native.u8[0], _native.u8[1], _native.u8[2], _native.u8[3],
				_native.u8[4], _native.u8[5], _native.u8[6], _native.u8[7] = b8, b7, b6, b5, b4, b3, b2, b1
				return _native.u64
			end,
		}
	}
}

_tags = {
	stop = 0,
	number = 1,
	string = 2,
	boolean = 3, -- not used anymore in version 1.2+
	table = 4,
	[true] = 5,
	[false] = 6,
}

_taggedWriters = {
	Blob.writeNumber,
	Blob.writeString,
	function() error('booleans are stored in tags; this error should never occur') end,
	Blob._writeTable,
	function(self) return self end, -- true is stored as tag, write nothing
	function(self) return self end, -- false is stored as tag, write nothing
}

_taggedReaders = {
	Blob.readNumber,
	Blob.readString,
	Blob.readBool,
	Blob.readTable,
	function() return true end,
	function() return false end,
}

_packMap = {
	b = Blob.writeS8,
	B = Blob.writeU8,
	h = Blob.writeS16,
	H = Blob.writeU16,
	l = Blob.writeS32,
	L = Blob.writeU32,
	V = Blob.writeVarU32,
	q = Blob.writeS64,
	Q = Blob.writeU64,
	f = Blob.writeFloat,
	d = Blob.writeNumber,
	n = Blob.writeNumber,
	c = Blob.writeRaw,
	s = Blob.writeString,
	z = Blob.writeCString,
	t = Blob.writeTable,
	y = Blob.writeBool,
	['<'] = function(self) self:setTargetEndian('<') end,
	['>'] = function(self) self:setTargetEndian('>') end,
	['='] = function(self) self:setTargetEndian('=') end,
}

_unpackMap = {
	b = Blob.readS8,
	B = Blob.readU8,
	h = Blob.readS16,
	H = Blob.readU16,
	l = Blob.readS32,
	L = Blob.readU32,
	V = Blob.readVarU32,
	q = Blob.readS64,
	Q = Blob.readU64,
	f = Blob.readFloat,
	d = Blob.readNumber,
	n = Blob.readNumber,
	c = Blob.readRaw,
	s = Blob.readString,
	z = Blob.readCString,
	t = Blob.readTable,
	y = Blob.readBool,
	['<'] = function(self) self:setSourceEndian('<') end,
	['>'] = function(self) self:setSourceEndian('>') end,
	['='] = function(self) self:setSourceEndian('=') end,
	[' '] = function(self) self:skip(1) end,
}

return setmetatable({}, {
	__call = function(self, ...)
		return setmetatable({}, { __index = Blob }):init(...)
	end
})
