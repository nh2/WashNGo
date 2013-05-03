module WASH.Utility.BulkIO where

import IO

import Ptr
import CString
import CTypes
import Foreign.Marshal.Alloc (mallocBytes, free)
import GHC.IO (hGetBuf, hPutBuf)
		   
rawGetBytes :: Handle -> Int -> IO String
rawGetBytes h n =
  do buf   <- mallocBytes n 	:: IO (Ptr CChar)
     count <- hGetBuf h buf n
     str   <- peekCStringLen (buf, count)
     free buf
     return str

bufferSize = 4096 :: Int

-- buffers could be shared at the price of MVars, which are not portable
rawHandleCopy :: Handle -> Handle -> IO ()
rawHandleCopy hin hout =
  do buf <- mallocBytes bufferSize
     let copy =
	   hGetBuf hin buf bufferSize >>= \count ->
	   if count == 0 
	      then return ()
	      else do
	        hPutBuf hout buf count
		copy
     copy
     free buf
