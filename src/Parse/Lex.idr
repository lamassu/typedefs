module Parse.Lex

import Text.Lexer
import Parse.Token as Tok

%access public export

isTDWhitespace : TypeToken -> Bool
isTDWhitespace tok = kind tok == Tok.Whitespace

ident : Lexer
ident = lower <+> alphaNums

-- TODO dedupe string literals
primType : Lexer
primType = exact "Unit" <|> exact "Void"

mu : Lexer
mu = exact "mu"

var : Lexer
var = exact "var"

prod : Lexer
prod = exact "*"

sum : Lexer
sum = exact "+"

lparen : Lexer
lparen = exact "("

rparen : Lexer
rparen = exact ")"

nat : Lexer
nat = digits

typedefsTokenMap : TokenMap TypeToken
typedefsTokenMap = toTokenMap
  [ (spaces   , Tok.Whitespace)
  , (nat      , Tok.Number)
  , (var      , Tok.Var)
  , (mu       , Tok.Mu)
  , (primType , Tok.PrimType)
  , (ident    , Tok.Ident)
  , (digits   , Tok.Number)
  , (sum      , Tok.NOp SumNO)
  , (prod     , Tok.NOp ProdNO)
  , (lparen   , Tok.Punct LParen)
  , (rparen   , Tok.Punct RParen)
  ]

typedef : String -> Maybe (List TypeToken)
typedef str =
  case lex typedefsTokenMap str of
       (tokens, _, _, "") => Just $ map TokenData.tok tokens
       _                  => Nothing
