{-# language DeriveFoldable #-}
{-# language DeriveFunctor #-}
{-# language DeriveTraversable #-}
{-# language GeneralizedNewtypeDeriving #-}
{-# language RankNTypes #-}
module Common where

import Protolude

newtype Global = Global Text
  deriving (Eq, Ord, Show, IsString, Hashable)

newtype NameHint = NameHint Text
  deriving (Show, IsString)

instance Eq NameHint where
  _ == _ = True

instance Ord NameHint where
  compare _ _ = EQ

newtype Constr = Constr Text
  deriving (Eq, Ord, Show, IsString, Hashable)

newtype Scope e v = Scope { unscope :: e v }
  deriving (Eq, Ord, Show, Foldable, Functor, Traversable)

type Scope1 = Scope

newtype Closed e = Closed { open :: forall v. e v }
