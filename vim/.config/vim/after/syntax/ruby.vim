syn match yardAttrName /@attr \h\+/hs=s+6 containedin=@yardTags contains=yardAttr
syn match yardAttrReaderName /@attr_reader \h\+/hs=s+13 containedin=@yardTags contains=yardAttrReader
syn match yardAttrWriterName /@attr_writer \h\+/hs=s+13 containedin=@yardTags contains=yardAttrWriter
