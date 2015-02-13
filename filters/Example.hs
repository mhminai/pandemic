#!/usr/bin/env haskell

import System.Process (readProcessWithExitCode)
import System.Exit (ExitCode(ExitSuccess))
import Data.ByteString.Lazy.UTF8 (fromString)
-- from the SHA package on HackageDB:
import Data.Digest.Pure.SHA (sha1, showDigest)
import System.FilePath ((</>))
import Control.Monad.Trans (liftIO)
import Text.Pandoc.JSON

transform :: Block -> IO Block
transform (CodeBlock (id, classes, namevals) contents) | "dot" `elem` classes = do
  let (name, outfile) =  case lookup "name" namevals of
                                Just fn   -> ([Str fn], fn ++ ".png")
                                Nothing   -> ([], uniqueName contents ++ ".png")
  liftIO $ do
    (ec, _out, err) <- readProcessWithExitCode "dot" ["-Tpng", "-o", "img/" ++ outfile] contents
    if ec == ExitSuccess
       then return $ Para [Image name ("img/" ++ outfile, "")]
       else error $ "dot returned an error status: " ++ err
transform x = return x

-- | Generate a unique filename given the file's contents.
uniqueName :: String -> String
uniqueName = showDigest . sha1 . fromString

main :: IO ()
main = toJSONFilter transform
