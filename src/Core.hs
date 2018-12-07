{-# language DeriveFoldable #-}
{-# language DeriveFunctor #-}
{-# language DeriveTraversable #-}
module Core where

import Protolude hiding (Type)

import Data.HashSet (HashSet)

import Common

data Expr v
  = Var !v
  | Global !Global
  | Con !Constr
  | Lam !NameHint (Type v) (Scope1 Expr v)
  | Pi !NameHint (Type v) v (HashSet v) (Scope1 Expr v)
  | App (Expr v) (Expr v)
  | Let !NameHint (Type v) (Expr v) (Scope1 Expr v)
  | LetRegion !NameHint (Scope1 Expr v)
  | Box !v (Expr v)
  | Unbox !v (Expr v)
  | Keep !v (Expr v)
  | Remember !(HashSet v) (Expr v)
  deriving (Eq, Show, Foldable)

type Type = Expr
