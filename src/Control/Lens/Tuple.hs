{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE Rank2Types #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
#ifdef TRUSTWORTHY
{-# LANGUAGE Trustworthy #-}
#endif

-------------------------------------------------------------------------------
-- |
-- Module      :  Control.Lens.Tuple
-- Copyright   :  (C) 2012-13 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  provisional
-- Portability :  Rank2Types
--
-------------------------------------------------------------------------------
module Control.Lens.Tuple
  (
  -- * Tuples
    Field1(..)
  , Field2(..)
  , Field3(..)
  , Field4(..)
  , Field5(..)
  , Field6(..)
  , Field7(..)
  , Field8(..)
  , Field9(..)
  ) where

import Control.Applicative
import Control.Lens.Combinators
import Control.Lens.Indexed
import Control.Lens.Type
import Data.Functor.Identity
import GHC.Generics (Generic (..), (:*:) (..), K1 (..), M1 (..), U1 (..))

-- $setup
-- >>> :set -XNoOverloadedStrings
-- >>> import Control.Lens

-- | Provides access to 1st field of a tuple.
class Field1 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 1st field of a tuple (and possibly change its type).
  --
  -- >>> (1,2)^._1
  -- 1
  --
  -- >>> _1 .~ "hello" $ (1,2)
  -- ("hello",2)
  --
  -- >>> (1,2) & _1 .~ "hello"
  -- ("hello",2)
  --
  -- >>> _1 putStrLn ("hello","world")
  -- hello
  -- ((),"world")
  --
  -- This can also be used on larger tuples as well:
  --
  -- >>> (1,2,3,4,5) & _1 +~ 41
  -- (42,2,3,4,5)
  --
  -- @
  -- '_1' :: 'Lens' (a,b) (a',b) a a'
  -- '_1' :: 'Lens' (a,b,c) (a',b,c) a a'
  -- '_1' :: 'Lens' (a,b,c,d) (a',b,c,d) a a'
  -- ...
  -- '_1' :: 'Lens' (a,b,c,d,e,f,g,h,i) (a',b,c,d,e,f,g,h,i) a a'
  -- @
  _1 :: Lens s t a b
#ifndef HLINT
  default _1 :: (Generic s, Generic t, GIxed N0 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _1 #-}
  _1 = ix proxyN0
#endif

instance Field1 (Identity a) (Identity b) a b where
  _1 f (Identity a) = Identity <$> indexed f (0 :: Int) a

-- | @
-- '_1' k ~(a,b) = (\\a' -> (a',b)) 'Data.Functor.<$>' k a
-- @
instance Field1 (a,b) (a',b) a a' where
  _1 k ~(a,b) = k a <&> \a' -> (a',b)
  {-# INLINE _1 #-}

instance Field1 (a,b,c) (a',b,c) a a' where
  _1 k ~(a,b,c) = k a <&> \a' -> (a',b,c)
  {-# INLINE _1 #-}

instance Field1 (a,b,c,d) (a',b,c,d) a a' where
  _1 k ~(a,b,c,d) = k a <&> \a' -> (a',b,c,d)
  {-# INLINE _1 #-}

instance Field1 (a,b,c,d,e) (a',b,c,d,e) a a' where
  _1 k ~(a,b,c,d,e) = k a <&> \a' -> (a',b,c,d,e)
  {-# INLINE _1 #-}

instance Field1 (a,b,c,d,e,f) (a',b,c,d,e,f) a a' where
  _1 k ~(a,b,c,d,e,f) = k a <&> \a' -> (a',b,c,d,e,f)
  {-# INLINE _1 #-}

instance Field1 (a,b,c,d,e,f,g) (a',b,c,d,e,f,g) a a' where
  _1 k ~(a,b,c,d,e,f,g) = k a <&> \a' -> (a',b,c,d,e,f,g)
  {-# INLINE _1 #-}

instance Field1 (a,b,c,d,e,f,g,h) (a',b,c,d,e,f,g,h) a a' where
  _1 k ~(a,b,c,d,e,f,g,h) = k a <&> \a' -> (a',b,c,d,e,f,g,h)
  {-# INLINE _1 #-}

instance Field1 (a,b,c,d,e,f,g,h,i) (a',b,c,d,e,f,g,h,i) a a' where
  _1 k ~(a,b,c,d,e,f,g,h,i) = k a <&> \a' -> (a',b,c,d,e,f,g,h,i)
  {-# INLINE _1 #-}

-- | Provides access to the 2nd field of a tuple.
class Field2 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 2nd field of a tuple.
  --
  -- >>> _2 .~ "hello" $ (1,(),3,4)
  -- (1,"hello",3,4)
  --
  -- >>> (1,2,3,4) & _2 *~ 3
  -- (1,6,3,4)
  --
  -- >>> _2 print (1,2)
  -- 2
  -- (1,())
  --
  -- @
  -- 'Control.Lens.Fold.anyOf' '_2' :: (s -> 'Bool') -> (a, s) -> 'Bool'
  -- 'Data.Traversable.traverse' '.' '_2' :: ('Control.Applicative.Applicative' f, 'Data.Traversable.Traversable' t) => (a -> f b) -> t (s, a) -> f (t (s, b))
  -- 'Control.Lens.Fold.foldMapOf' ('Data.Traversable.traverse' '.' '_2') :: ('Data.Traversable.Traversable' t, 'Data.Monoid.Monoid' m) => (s -> m) -> t (b, s) -> m
  -- @
  _2 :: Lens s t a b
#ifndef HLINT
  default _2 :: (Generic s, Generic t, GIxed N1 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _2 #-}
  _2 = ix proxyN1
#endif

-- | @
-- '_2' k ~(a,b) = (\\b' -> (a,b')) 'Data.Functor.<$>' k b
-- @
instance Field2 (a,b) (a,b') b b' where
  _2 k ~(a,b) = k b <&> \b' -> (a,b')
  {-# INLINE _2 #-}

instance Field2 (a,b,c) (a,b',c) b b' where
  _2 k ~(a,b,c) = k b <&> \b' -> (a,b',c)
  {-# INLINE _2 #-}

instance Field2 (a,b,c,d) (a,b',c,d) b b' where
  _2 k ~(a,b,c,d) = k b <&> \b' -> (a,b',c,d)
  {-# INLINE _2 #-}

instance Field2 (a,b,c,d,e) (a,b',c,d,e) b b' where
  _2 k ~(a,b,c,d,e) = k b <&> \b' -> (a,b',c,d,e)
  {-# INLINE _2 #-}

instance Field2 (a,b,c,d,e,f) (a,b',c,d,e,f) b b' where
  _2 k ~(a,b,c,d,e,f) = k b <&> \b' -> (a,b',c,d,e,f)
  {-# INLINE _2 #-}

instance Field2 (a,b,c,d,e,f,g) (a,b',c,d,e,f,g) b b' where
  _2 k ~(a,b,c,d,e,f,g) = k b <&> \b' -> (a,b',c,d,e,f,g)
  {-# INLINE _2 #-}

instance Field2 (a,b,c,d,e,f,g,h) (a,b',c,d,e,f,g,h) b b' where
  _2 k ~(a,b,c,d,e,f,g,h) = k b <&> \b' -> (a,b',c,d,e,f,g,h)
  {-# INLINE _2 #-}

instance Field2 (a,b,c,d,e,f,g,h,i) (a,b',c,d,e,f,g,h,i) b b' where
  _2 k ~(a,b,c,d,e,f,g,h,i) = k b <&> \b' -> (a,b',c,d,e,f,g,h,i)
  {-# INLINE _2 #-}

-- | Provides access to the 3rd field of a tuple.
class Field3 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 3rd field of a tuple.
  _3 :: Lens s t a b
#ifndef HLINT
  default _3 :: (Generic s, Generic t, GIxed N2 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _3 #-}
  _3 = ix proxyN2
#endif

instance Field3 (a,b,c) (a,b,c') c c' where
  _3 k ~(a,b,c) = k c <&> \c' -> (a,b,c')
  {-# INLINE _3 #-}

instance Field3 (a,b,c,d) (a,b,c',d) c c' where
  _3 k ~(a,b,c,d) = k c <&> \c' -> (a,b,c',d)
  {-# INLINE _3 #-}

instance Field3 (a,b,c,d,e) (a,b,c',d,e) c c' where
  _3 k ~(a,b,c,d,e) = k c <&> \c' -> (a,b,c',d,e)
  {-# INLINE _3 #-}

instance Field3 (a,b,c,d,e,f) (a,b,c',d,e,f) c c' where
  _3 k ~(a,b,c,d,e,f) = k c <&> \c' -> (a,b,c',d,e,f)
  {-# INLINE _3 #-}

instance Field3 (a,b,c,d,e,f,g) (a,b,c',d,e,f,g) c c' where
  _3 k ~(a,b,c,d,e,f,g) = k c <&> \c' -> (a,b,c',d,e,f,g)
  {-# INLINE _3 #-}

instance Field3 (a,b,c,d,e,f,g,h) (a,b,c',d,e,f,g,h) c c' where
  _3 k ~(a,b,c,d,e,f,g,h) = k c <&> \c' -> (a,b,c',d,e,f,g,h)
  {-# INLINE _3 #-}

instance Field3 (a,b,c,d,e,f,g,h,i) (a,b,c',d,e,f,g,h,i) c c' where
  _3 k ~(a,b,c,d,e,f,g,h,i) = k c <&> \c' -> (a,b,c',d,e,f,g,h,i)
  {-# INLINE _3 #-}

-- | Provide access to the 4th field of a tuple.
class Field4 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 4th field of a tuple.
  _4 :: Lens s t a b
#ifndef HLINT
  default _4 :: (Generic s, Generic t, GIxed N3 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _4 #-}
  _4 = ix proxyN3
#endif

instance Field4 (a,b,c,d) (a,b,c,d') d d' where
  _4 k ~(a,b,c,d) = k d <&> \d' -> (a,b,c,d')
  {-# INLINE _4 #-}

instance Field4 (a,b,c,d,e) (a,b,c,d',e) d d' where
  _4 k ~(a,b,c,d,e) = k d <&> \d' -> (a,b,c,d',e)
  {-# INLINE _4 #-}

instance Field4 (a,b,c,d,e,f) (a,b,c,d',e,f) d d' where
  _4 k ~(a,b,c,d,e,f) = k d <&> \d' -> (a,b,c,d',e,f)
  {-# INLINE _4 #-}

instance Field4 (a,b,c,d,e,f,g) (a,b,c,d',e,f,g) d d' where
  _4 k ~(a,b,c,d,e,f,g) = k d <&> \d' -> (a,b,c,d',e,f,g)
  {-# INLINE _4 #-}

instance Field4 (a,b,c,d,e,f,g,h) (a,b,c,d',e,f,g,h) d d' where
  _4 k ~(a,b,c,d,e,f,g,h) = k d <&> \d' -> (a,b,c,d',e,f,g,h)
  {-# INLINE _4 #-}

instance Field4 (a,b,c,d,e,f,g,h,i) (a,b,c,d',e,f,g,h,i) d d' where
  _4 k ~(a,b,c,d,e,f,g,h,i) = k d <&> \d' -> (a,b,c,d',e,f,g,h,i)
  {-# INLINE _4 #-}

-- | Provides access to the 5th field of a tuple.
class Field5 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 5th field of a tuple.
  _5 :: Lens s t a b
#ifndef HLINT
  default _5 :: (Generic s, Generic t, GIxed N4 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _5 #-}
  _5 = ix proxyN4
#endif

instance Field5 (a,b,c,d,e) (a,b,c,d,e') e e' where
  _5 k ~(a,b,c,d,e) = k e <&> \e' -> (a,b,c,d,e')
  {-# INLINE _5 #-}

instance Field5 (a,b,c,d,e,f) (a,b,c,d,e',f) e e' where
  _5 k ~(a,b,c,d,e,f) = k e <&> \e' -> (a,b,c,d,e',f)
  {-# INLINE _5 #-}

instance Field5 (a,b,c,d,e,f,g) (a,b,c,d,e',f,g) e e' where
  _5 k ~(a,b,c,d,e,f,g) = k e <&> \e' -> (a,b,c,d,e',f,g)
  {-# INLINE _5 #-}

instance Field5 (a,b,c,d,e,f,g,h) (a,b,c,d,e',f,g,h) e e' where
  _5 k ~(a,b,c,d,e,f,g,h) = k e <&> \e' -> (a,b,c,d,e',f,g,h)
  {-# INLINE _5 #-}

instance Field5 (a,b,c,d,e,f,g,h,i) (a,b,c,d,e',f,g,h,i) e e' where
  _5 k ~(a,b,c,d,e,f,g,h,i) = k e <&> \e' -> (a,b,c,d,e',f,g,h,i)
  {-# INLINE _5 #-}

-- | Provides access to the 6th element of a tuple.
class Field6 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 6th field of a tuple.
  _6 :: Lens s t a b
#ifndef HLINT
  default _6 :: (Generic s, Generic t, GIxed N5 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _6 #-}
  _6 = ix proxyN5
#endif

instance Field6 (a,b,c,d,e,f) (a,b,c,d,e,f') f f' where
  _6 k ~(a,b,c,d,e,f) = k f <&> \f' -> (a,b,c,d,e,f')
  {-# INLINE _6 #-}

instance Field6 (a,b,c,d,e,f,g) (a,b,c,d,e,f',g) f f' where
  _6 k ~(a,b,c,d,e,f,g) = k f <&> \f' -> (a,b,c,d,e,f',g)
  {-# INLINE _6 #-}

instance Field6 (a,b,c,d,e,f,g,h) (a,b,c,d,e,f',g,h) f f' where
  _6 k ~(a,b,c,d,e,f,g,h) = k f <&> \f' -> (a,b,c,d,e,f',g,h)
  {-# INLINE _6 #-}

instance Field6 (a,b,c,d,e,f,g,h,i) (a,b,c,d,e,f',g,h,i) f f' where
  _6 k ~(a,b,c,d,e,f,g,h,i) = k f <&> \f' -> (a,b,c,d,e,f',g,h,i)
  {-# INLINE _6 #-}

-- | Provide access to the 7th field of a tuple.
class Field7 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 7th field of a tuple.
  _7 :: Lens s t a b
#ifndef HLINT
  default _7 :: (Generic s, Generic t, GIxed N6 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _7 #-}
  _7 = ix proxyN6
#endif

instance Field7 (a,b,c,d,e,f,g) (a,b,c,d,e,f,g') g g' where
  _7 k ~(a,b,c,d,e,f,g) = k g <&> \g' -> (a,b,c,d,e,f,g')
  {-# INLINE _7 #-}

instance Field7 (a,b,c,d,e,f,g,h) (a,b,c,d,e,f,g',h) g g' where
  _7 k ~(a,b,c,d,e,f,g,h) = k g <&> \g' -> (a,b,c,d,e,f,g',h)
  {-# INLINE _7 #-}

instance Field7 (a,b,c,d,e,f,g,h,i) (a,b,c,d,e,f,g',h,i) g g' where
  _7 k ~(a,b,c,d,e,f,g,h,i) = k g <&> \g' -> (a,b,c,d,e,f,g',h,i)
  {-# INLINE _7 #-}

-- | Provide access to the 8th field of a tuple.
class Field8 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 8th field of a tuple.
  _8 :: Lens s t a b
#ifndef HLINT
  default _8 :: (Generic s, Generic t, GIxed N7 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _8 #-}
  _8 = ix proxyN7
#endif

instance Field8 (a,b,c,d,e,f,g,h) (a,b,c,d,e,f,g,h') h h' where
  _8 k ~(a,b,c,d,e,f,g,h) = k h <&> \h' -> (a,b,c,d,e,f,g,h')
  {-# INLINE _8 #-}

instance Field8 (a,b,c,d,e,f,g,h,i) (a,b,c,d,e,f,g,h',i) h h' where
  _8 k ~(a,b,c,d,e,f,g,h,i) = k h <&> \h' -> (a,b,c,d,e,f,g,h',i)
  {-# INLINE _8 #-}

-- | Provides access to the 9th field of a tuple.
class Field9 s t a b | s -> a, t -> b, s b -> t, t a -> s where
  -- | Access the 9th field of a tuple.
  _9 :: Lens s t a b
#ifndef HLINT
  default _9 :: (Generic s, Generic t, GIxed N8 (Rep s) (Rep t) a b)
             => Lens s t a b
  {-# INLINE _9 #-}
  _9 = ix proxyN8
#endif

instance Field9 (a,b,c,d,e,f,g,h,i) (a,b,c,d,e,f,g,h,i') i i' where
  _9 k ~(a,b,c,d,e,f,g,h,i) = k i <&> \i' -> (a,b,c,d,e,f,g,h,i')
  {-# INLINE _9 #-}

ix :: (Generic s, Generic t, GIxed n (Rep s) (Rep t) a b) => f n -> Lens s t a b
{-# INLINE ix #-}
ix n f = fmap to . gix n f . from

#ifndef HLINT
type family GSize (f :: * -> *) :: Nat
#endif
type instance GSize U1 = Z
type instance GSize (K1 i c) = S Z
type instance GSize (M1 i c f) = GSize f
type instance GSize (a :*: b) = Add (GSize a) (GSize b)

#ifndef HLINT
class GIxed (n :: Nat) s t a b | n s -> a, n t -> b, n s b -> t, n t a -> s where
  gix :: f n -> Lens (s x) (t x) a b
#endif

instance GIxed N0 (K1 i a) (K1 i b) a b where
  {-# INLINE gix #-}
  gix _ = \ f -> fmap K1 . f . unK1

instance GIxed n s t a b => GIxed n (M1 i c s) (M1 i c t) a b where
  {-# INLINE gix #-}
  gix n = \ f -> fmap M1 . gix n f . unM1

instance GIxed' (GT (GSize s) n) n s s' t t' a b
      => GIxed n (s :*: s') (t :*: t') a b where
  {-# INLINE gix #-}
  gix n = \ f ~s@(a :*: _) -> gix' (proxySizeGT a n) n f s

proxySizeGT :: s x -> p n -> BoolP (GT (GSize s) n)
{-# INLINE proxySizeGT #-}
proxySizeGT _ _ = BoolP

#ifndef HLINT
class GIxed' (p :: Bool) (n :: Nat) s s' t t' a b where
  gix' :: f p -> g n -> Lens ((s :*: s') x) ((t :*: t') x) a b
#endif

instance GIxed n s t a b => GIxed' True n s s' t s' a b where
  {-# INLINE gix' #-}
  gix' _ n = \ f (s :*: s') -> fmap (:*: s') $ gix n f s

instance GIxed (Subtract (GSize s) n) s' t' a b
      => GIxed' False n s s' s t' a b where
  {-# INLINE gix' #-}
  gix' _ n = \ f (s :*: s') -> fmap (s :*:) $ gix (proxySubtractSize s n) f s'

proxySubtractSize :: s x -> p n -> NatP (Subtract (GSize s) n)
{-# INLINE proxySubtractSize #-}
proxySubtractSize _ _ = NatP

data Nat = Z | S Nat

#ifndef HLINT
type family Add (x :: Nat) (y :: Nat) :: Nat
#endif
type instance Add Z y = y
type instance Add (S x) y = S (Add x y)

#ifndef HLINT
type family Subtract (x :: Nat) (y :: Nat) :: Nat
#endif
type instance Subtract Z x = x
type instance Subtract (S x) (S y) = Subtract x y

#ifndef HLINT
type family GT (x :: Nat) (y :: Nat) :: Bool
#endif
type instance GT Z x = False
type instance GT (S x) Z = True
type instance GT (S x) (S y) = GT x y

type N0 = Z
type N1 = S N0
type N2 = S N1
type N3 = S N2
type N4 = S N3
type N5 = S N4
type N6 = S N5
type N7 = S N6
type N8 = S N7

#ifndef HLINT
data NatP (n :: Nat) = NatP
#endif

proxyN0 :: NatP N0
{-# INLINE proxyN0 #-}
proxyN0 = NatP

proxyN1 :: NatP N1
{-# INLINE proxyN1 #-}
proxyN1 = NatP

proxyN2 :: NatP N2
{-# INLINE proxyN2 #-}
proxyN2 = NatP

proxyN3 :: NatP N3
{-# INLINE proxyN3 #-}
proxyN3 = NatP

proxyN4 :: NatP N4
{-# INLINE proxyN4 #-}
proxyN4 = NatP

proxyN5 :: NatP N5
{-# INLINE proxyN5 #-}
proxyN5 = NatP

proxyN6 :: NatP N6
{-# INLINE proxyN6 #-}
proxyN6 = NatP

proxyN7 :: NatP N7
{-# INLINE proxyN7 #-}
proxyN7 = NatP

proxyN8 :: NatP N8
{-# INLINE proxyN8 #-}
proxyN8 = NatP

#ifndef HLINT
data BoolP (b :: Bool) = BoolP
#endif
