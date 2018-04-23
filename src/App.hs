{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module App where

import           Control.Monad.Except       (ExceptT, MonadError, runExceptT)
import           Control.Monad.Identity     (Identity, runIdentity)
import           Control.Monad.State.Strict (MonadState, StateT, execStateT)
import qualified Data.Map                   as M
import           Data.Semigroup             ((<>))

import           Types

newtype App a = App (StateT UTXOs (ExceptT String Identity) a)
    deriving (Functor, Applicative, Monad, MonadState UTXOs, MonadError String)

runApp :: App a -> UTXOs -> Either String UTXOs
runApp (App a) utxo = runIdentity (runExceptT (execStateT a utxo))

prettyPrint :: Either String UTXOs -> IO ()
prettyPrint (Left e) = putStrLn $ "Warning: " <> e
prettyPrint (Right utxo) = putStrLn $ M.foldrWithKey
   (\k v acc -> show k <> " " <>  show v <> "\n" <> acc ) "" utxo
