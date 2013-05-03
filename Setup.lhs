#!/usr/bin/env runhaskell
arch-tag: Main setup script

> import Distribution.Simple
> import Distribution.Simple.Configure
> import Distribution.Simple.LocalBuildInfo
> import Distribution.Setup
> import Distribution.PackageDescription
> import IO
> import System
> import System.Posix.Files

> main = defaultMainWithHooks myUserHooks

> myUserHooks = 
>   defaultUserHooks 
>     { instHook = myInstaller
>     }
> 
> myInstaller :: PackageDescription -> LocalBuildInfo -> Maybe UserHooks -> InstallFlags -> IO ()
> myInstaller pdesc lbi mhook userFlags =
>   do instHook defaultUserHooks pdesc lbi mhook userFlags
>      myPostInstaller pdesc userFlags lbi
> 
> -- | Build and install the shell script to invoke the Haskell compiler with 
> -- the correct flags
> myPostInstaller :: PackageDescription -> InstallFlags -> LocalBuildInfo -> IO ()
> myPostInstaller pdesc instFlags localBuildInfo =
>   let hc = compiler localBuildInfo
>	bindir = prefix localBuildInfo ++ "/bin"
>	generated = bindir ++ "/washc"
>	pid = showPackageId (package pdesc)
>   in
>   do h <- openFile generated WriteMode
>      hPutStrLn h "#!/bin/sh"
>      hPutStr h (compilerPath hc)
>      hPutStr h " -pgmF "
>      hPutStr h bindir
>      hPutStr h "/wash2hs"
>      hPutStr h " -F -package "
>      hPutStr h pid
>      hPutStrLn h " $@"
>      hClose h
>      let allMayExec = foldr unionFileModes nullFileMode [ownerModes, groupExecuteMode, groupReadMode, otherExecuteMode, otherReadMode]
>      setFileMode generated allMayExec

This does not work properly. It does not give others execute permission.

> --     perms <- getPermissions generated
> --     setPermissions generated perms { executable = True, readable = True }

