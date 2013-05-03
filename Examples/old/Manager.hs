module Main where

import WASH.Utility.Auxiliary
import WASH.CGI.Submit

baseDirectory = "/tmp/Submittals"

main = 
  do { pathInfo <- protectedGetEnv "PATH_INFO" ""
     ; let ?storeDirectory = baseDirectory ++ pathInfo ++ "/" in
       let ?venuePath = pathInfo in
       entryPage 
     }

