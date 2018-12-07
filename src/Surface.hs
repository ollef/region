{-# language DeriveFoldable #-}
{-# language DeriveFunctor #-}
{-# language DeriveTraversable #-}
module Surface where

import Protolude hiding (Type)

import Common

data Expr v
  = Var !v
  | Global !Global
  | Lam !NameHint (Type v) (Scope1 Expr v)
  | Pi !NameHint (Type v) (Scope1 Expr v)
  | App (Expr v) (Expr v)
  | Let !NameHint (Type v) (Expr v) (Scope1 Expr v)
  | Box (Expr v)
  | Unbox (Expr v)
  deriving (Foldable, Functor, Traversable)

type Type = Expr
