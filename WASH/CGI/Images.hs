module WASH.CGI.Images (nothing, question, nothingURL, questionURL) where

import WASH.CGI.CGITypes
import WASH.Utility.RFC2397
import WASH.Utility.JavaScript

rawNothing1 = "GIF89a\SOH\NUL\SOH\NUL\128\NUL\NUL\NUL\NUL\NUL\NUL\NUL\216!\249\EOT\SOH\NUL\NUL\NUL\NUL,\NUL\NUL\NUL\NUL\SOH\NUL\SOH\NUL\NUL\STX\STXD\SOH\NUL;"
rawNothing = "GIF89a\DLE\NUL\DLE\NUL\128\NUL\NUL\NUL\NUL\NUL\NUL\NUL\NUL!\249\EOT\SOH\NUL\NUL\NUL\NUL,\NUL\NUL\NUL\NUL\DLE\NUL\DLE\NUL\NUL\STX\SO\132\143\169\203\237\SI\163\156\180\218\139\179>\ENQ\NUL;"

rawQuestion = "GIF89a\DLE\NUL\DLE\NUL\128\NUL\NUL\NUL\NUL\NUL\255\NUL\NUL!\249\EOT\SOH\NUL\NUL\NUL\NUL,\NUL\NUL\NUL\NUL\DLE\NUL\DLE\NUL\NUL\STX#\132\GS\EM\199\167\191\SUBP\140\182$\177\204\250\194\238\129\155\181Ub9E\136\SUB~\229\199\162\242\140\146\178}\DC4\NUL;"

nothing = FreeForm "nothing.gif" "image/gif" rawNothing
question = FreeForm "question.gif" "image/gif" rawQuestion

nothingURL = "javascript:" ++ jsShow rawNothing
questionURL = "javascript:" ++ jsShow rawQuestion

-- data URL not universally supported
nothingURLdata  = encode ("image/gif", rawNothing)
questionURLdata = encode ("image/gif", rawQuestion)
