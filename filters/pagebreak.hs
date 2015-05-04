--
-- Pandoc filter from the groups discussion page. Mail pasted below. Check group archives for history
--John MacFarlane <jgm@berkeley.edu>: Apr 22 08:44AM -0700
-- >insertPgBrks blk = blk
-- >main = toJSONFilter insertPgBrks
-- >Question: Are the opening imports necessary?
-- You should only need Text.Pandoc.JSON.
-- To see why this didn't work, I did `pandoc -t native` and saw that
-- hi
-- \newpage
-- there
-- comes out as
-- [Para [Str "hi"]
-- ,Para [RawInline (Format "tex") "\\newpage"]
-- ,Para [Str "there"]]
-- This strikes me as a bug -- \newpage should be a block element.
-- I'll fix that later. For now, you could add a clause
-- insertPgBrks (Para [RawInline (Format "tex") "\newpage"]) = pgBrkBlock 
--
--
import Text.Pandoc.JSON
 
pgBrkXml :: String
pgBrkXml = "<w:p><w:r><w:br w:type=\"page\"/></w:r></w:p>"
 
pgBrkBlock :: Block
pgBrkBlock = RawBlock (Format "openxml") pgBrkXml
 
insertPgBrks :: Block -> Block
insertPgBrks (Para [RawInline (Format "tex") "\\newpage"]) = pgBrkBlock
--insertPgBrks (RawBlock (Format "tex") "\newpage") = pgBrkBlock
insertPgBrks blk = blk
 
main = toJSONFilter insertPgBrks
