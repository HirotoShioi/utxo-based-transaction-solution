{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module App where

import Control.Monad.Except
import Control.Monad.State.Strict
import Control.Monad.Identity

import qualified Data.Map as M

import Data.Monoid ((<>))

import Types

newtype App a = App (StateT UTXOs (ExceptT String Identity) a)
  deriving (Functor, Applicative, Monad, MonadState UTXOs, MonadError String)

runApp :: App a -> UTXOs -> Either String UTXOs
runApp (App a) utxo = runIdentity (runExceptT (execStateT a utxo))

prettyPrint :: Either String UTXOs -> IO ()
prettyPrint (Left e) = putStrLn $ "Warning: " <> e
prettyPrint (Right utxo) = putStrLn $ M.foldrWithKey 
  (\k v acc -> show k <> " " <>  show v <> "\n" <> acc ) "" utxo