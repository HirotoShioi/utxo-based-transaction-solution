module Dummy where

import Types

import qualified Data.Map as M

utxos :: UTXOs
utxos = M.fromList [(input0, output0), (input0', output0')]

input0 :: Input
input0 = Input 0 0

output0 :: Output
output0 = Output 100000 "Genesis"

input0' :: Input
input0' = Input 0 1

output0' :: Output
output0' = Output 100 "Hiroto"

transaction1 :: Transaction
transaction1 = Transaction 1 [input1] [output1, output2]

input1 :: Input
input1 = Input 0 0

output1 :: Output
output1 = Output 2000 "Lars"

output2 :: Output
output2 = Output 20000 "Andres"

transaction2 :: Transaction
transaction2 = Transaction 2 [input3, input4] [output3, output4, output5]

input3 :: Input
input3 = Input 0 1

input4 :: Input
input4 = Input 1 1

output3 :: Output
output3 = Output 5000 "Charles"

output4 :: Output
output4 = Output 5000 "Jeremy"

output5 :: Output
output5 = Output 1000 "Hiroto"