{-# LANGUAGE RecordWildCards #-}

module Transaction
　　　　(
  　　　　processTransactions
　　　　) where

import           Control.Monad.Except (throwError)
import           Control.Monad.State  (get, modify, when, zipWithM)
import qualified Data.Map             as M
import           Data.Semigroup       ((<>))

import           App                  (App)
import           Types                (Id, Index, Input (..), Output (..),
                                       Transaction (..))

-- | Process transaction
processTransaction :: Transaction -> App ()
processTransaction Transaction{..} = do
    inputValue <- processInputs tId tInput
    outputValue <- processOutputs tId tOutput
    when (inputValue < outputValue) $
        throwError $ "Infuccient amount, tId: " <> show tId
          <> "\n Input is less than output by: " <> show (outputValue - inputValue)

-- | Process list of tranactions
processTransactions :: [Transaction] -> App ()
processTransactions = mapM_ processTransaction

-- | Process list of inputs
processInputs :: Id -> [Input] -> App Int
processInputs tid inputs = sum <$> mapM (processInput tid) inputs

-- | Process inputs i.e. check it is valid, update utxos, and return unspent value
processInput :: Id -> Input -> App Int
processInput tid input = do
    utxos <- get
    case M.lookup input utxos of  -- Check if the input is valid
        Nothing         -> throwError $ "Invalid input at: " <> show tid
        Just Output{..} -> do
            modify $ M.delete input   -- Delete the input from utxos
            return oValue             -- Return output value

-- | Process list of outputs
processOutputs :: Id -> [Output] -> App Int
processOutputs tid outputs = sum <$> zipWithM (processOutput tid) [0..] outputs

-- | Process outputs i.e. Update utxos accordingly then return output value
processOutput :: Id -> Index -> Output -> App Int
processOutput tid i output@Output{..} = do
    modify $ M.insert (Input tid i) output  -- Update utxos accordingly
    return oValue                           -- Return a value
