# Blob.lua - binary serialization library

Blob.lua is a small LuaJIT library that performs serialization into a compact binary format. It can be used to parse arbitrary binary data, or to serialize data for efficient storage or transmission.

## How to use

### Reading data

	local Blob = require('Blob')

	-- Load data from file
	local file = io.open('filename.ext', 'rb')
	local blob = Blob(file:read('*all'))
	file:close()

	-- Parse binary data
	local u8 = blob:readU8()
	local s16 = blob:readS8()
	local str = blob:readCString()
	local float = blob:readFloat()
	...

	-- Read Lua types
	local tbl = blob:readTable()
	local bool = blob:readBool() -- 8 bits, 0 == false
	local num = blob:readNumber()
	local str = blob:readString()

### Writing data

	local Blob = require('Blob')

	-- Create a new Blob for writing
	blob = Blob()

	-- Store binary data
	blob
		:writeU8(23)
		:writeNumber(123.45)
		:writeFloat(23.0)
		:writeCString('string')
		...

	-- Store Lua types
	blob
		:write({ key = 'value', tbl = { 1, 2, 3 } }) -- no cycles allowed!
		:write(23)
		:write(true)
		:write('string')

	-- Write data to file
	local file = io.open('filename.ext', 'wb')
	file:write(blob:string())
	file:close()

## Operation modes

A blob has two basic operation modes: raw and formatted I/O.

### Raw I/O

This mode provides a low level interface for handling arbitrary binary data. These functions are available for raw I/O:

	Blob:readS8 / Blob:readU8   -- reads a signed/unsigned 8 bit integer value
	Blob:readS16 / Blob:readU16 -- reads a signed/unsigned 16 bit integer value
	Blob:readS32 / Blob:readU32 -- reads a signed/unsigned 32 bit integer value
	Blob:readS64 / Blob:readU64 -- reads a signed/unsigned 64 bit integer value
	Blob:readVarU32             -- reads a length-optimized unsigned 32 bit value written by writeVarU32()
	Blob:readFloat              -- reads a 32 bit floating point value
	Blob:readNumber             -- reads a Lua number (64 bit floating point)
	Blob:readBool               -- reads a boolean value (8 bits; 0 == false)
	Blob:readString             -- reads a string written by writeString()
	Blob:readTable              -- reads a table written by writeTable()
	Blob:readRaw                -- reads raw binary data (length must be specified)
	Blob:readCString            -- reads a zero-terminated string

Each of these functions has a `write*` counterpart.

To describe the raw data format in a more concise manner, use [`Blob:pack`](https://github.com/megagrump/blob/wiki/API-documentation#blobpackformat-) and [`Blob:unpack`](https://github.com/megagrump/blob/wiki/API-documentation#blobunpackformat). These functions work similar to `string.unpack` and `string.pack` in Lua 5.3, although some details are different (fixed instead of native data sizes; more supported data types; some features are not implemented). See [API documentation](https://github.com/megagrump/blob/wiki/API-documentation) for details.

Raw I/O does not store type information and does not perform any kind of type checking, except for strings (length is being stored) and tables (field type information is being stored). Tables are limited in what types they can hold as described under 'Formatted I/O'.

### Formatted I/O

This mode is intended for simple serialization of Lua values. Formatted I/O provides two functions, [`Blob:read()`](https://github.com/megagrump/blob/wiki/API-documentation#blobread) and [`Blob:write()`](https://github.com/megagrump/blob/wiki/API-documentation#blobwritevalue). Since it relies on metadata about the stored value types, `Blob:read()` can only read data that was previously written by `Blob:write()`.

These data types are supported by `Blob:read()` and `Blob:write()`:
* `number` (64 bit)
* `string` (up to 2^32-1 bytes)
* `boolean`
* `table`

Type and length information will be added as metadata by the write() function. Metadata overhead is 1 byte per value written for type information, and between 1 and 5 bytes per string written for length information. Tables can contain `number`, `string`, `boolean`, and `table` as key and value types. An error is being thrown if other types or cyclic nested tables are encountered.

### Documentation

[API documentation](https://github.com/megagrump/blob/wiki/API-documentation)

### Compatibility

Since Blob.lua uses the ffi library and C data types, it is not compatible with vanilla Lua and can only be used with LuaJIT.

### License

Copyright 2017, 2018 megagrump

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
