#!/usr/bin/env runhaskell
arch-tag: Main setup script

> import Distribution.Simple
> import Distribution.Simple.Configure
> import Distribution.Simple.LocalBuildInfo
> import Distribution.Simple.Setup
> import Distribution.PackageDescription
> import Distribution.Text (display)
> import System.IO
> import System.Posix.Files

> main = defaultMainWithHooks myUserHooks

> myUserHooks = 
>   defaultUserHooks 
>     { instHook = myInstaller
>     }
> 
> myInstaller :: PackageDescription -> LocalBuildInfo -> UserHooks -> InstallFlags -> IO ()
> myInstaller pdesc lbi hook userFlags =
>   do instHook defaultUserHooks pdesc lbi hook userFlags
>      myPostInstaller pdesc userFlags lbi
> 
> -- | Build and install the shell script to invoke the Haskell compiler with 
> -- the correct flags
> myPostInstaller :: PackageDescription -> InstallFlags -> LocalBuildInfo -> IO ()
> myPostInstaller pdesc instFlags localBuildInfo =
>   let hc = compiler localBuildInfo
>	bindir = prefix (absoluteInstallDirs pdesc localBuildInfo NoCopyDest) ++ "/bin" -- TODO check if NoCopyDest is correct
>	generated = bindir ++ "/washc"
>	pid = display (package pdesc)
>   in
>   do h <- openFile generated WriteMode
>      hPutStrLn h "#!/bin/sh"
>      hPutStr h "ghc"
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

