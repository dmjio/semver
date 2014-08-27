{-# LANGUAGE OverloadedStrings #-}

-- Module      : Main
-- Copyright   : (c) 2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Main (main) where

import Control.Applicative
import Data.Int
import Data.List             (intercalate)
import Data.Maybe            (fromMaybe)
import Data.Word
--import Test.QuickCheck
import Test.Tasty
import Test.Tasty.QuickCheck
import Text.Printf

main :: IO ()
main = defaultMain $ testGroup "Tests"
    [ testGroup "Encoding" []
    , testGroup "Parsing" []
    , testGroup "Precedence" []
    ]

-- Precedence refers to how versions are compared to each other when
-- ordered. Precedence MUST be calculated by separating the version into major,
-- minor, patch and pre-release identifiers in that order (Build metadata does not
-- figure into precedence). Precedence is determined by the first difference when
-- comparing each of these identifiers from left to right as follows: Major,
-- minor, and patch versions are always compared numerically. Example: 1.0.0 <
-- 2.0.0 < 2.1.0 < 2.1.1. When major, minor, and patch are equal, a pre-release
-- version has lower precedence than a normal version. Example: 1.0.0-alpha <
-- 1.0.0. Precedence for two pre-release versions with the same major, minor, and
-- patch version MUST be determined by comparing each dot separated identifier
-- from left to right until a difference is found as follows: identifiers
-- consisting of only digits are compared numerically and identifiers with letters
-- or hyphens are compared lexically in ASCII sort order. Numeric identifiers
-- always have lower precedence than non-numeric identifiers. A larger set of
-- pre-release fields has a higher precedence than a smaller set, if all of the
-- preceding identifiers are equal. Example: 1.0.0-alpha < 1.0.0-alpha.1 <
-- 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 <
-- 1.0.0.
