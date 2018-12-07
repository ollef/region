{-# language OverloadedStrings #-}
{-# language TemplateHaskell #-}
module Elaboration where

import Protolude

import Control.Lens
import Data.HashMap.Lazy (HashMap)
import Data.HashSet (HashSet)
import Data.IORef

import Common
import qualified Core
import qualified Surface

data Var = Var
  { _id :: !Int
  , _hint :: !NameHint
  , _type_ :: !(Core.Expr Var)
  }

makeLenses ''Var

instance Eq Var where
  (==) = (==) `on` view id

instance Ord Var where
  compare = comparing $ view id

instance Hashable Var where
  hashWithSalt s v = hashWithSalt s $ v^.id

data Env = Env
  { _globals :: !(HashMap Global (Closed Core.Type))
  , _fresh :: !(IORef Int)
  }

makeLenses ''Env

type Elab = ReaderT Env IO

infer :: Surface.Expr Var -> Elab (Core.Expr Var, Core.Type Var, HashSet Var)
infer (Surface.Var v) = return (Core.Var v, v^.type_, mempty)
infer (Surface.Global g) = do
  maybeType <- view $ globals.at g
  case maybeType of
    Nothing -> panic $ "Not in scope: " <> show g
    Just (Closed typ) -> return (Core.Global g, typ, mempty)
infer (Surface.Lam h typ (Scope e)) = do
