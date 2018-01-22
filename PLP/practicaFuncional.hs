

maxi :: (Int, Int) -> Int
maxi (x, y) | x >= y = x
            | otherwise = y 

curry2:: ((a,b)->c) -> (a->b->c)
curry2 f a b = f (a,b)

partir:: [a] -> [([a], [a])]
partir xs = (\xs-> [(take a xs, drop a xs) | a<-[0..length(xs)]]) xs


listasQueSuman:: Int -> [[Int]]
listasQueSuman 0 = []
listasQueSuman n = todasLasListasQueSumanHasta n

todasLasListasQueSumanHasta:: Int -> [[Int]]
todasLasListasQueSumanHasta 0 = []
todasLasListasQueSumanHasta n = [n] : concat [sumarN (i,todasLasListasQueSumanHasta (n-i)) | i<-[1..n-1]]


sumarN:: (Int, [[Int]]) -> [[Int]]
sumarN (n,l) = map (\xs -> n : xs) l


listaDeListasFinitas = [listasQueSuman x | x<-[1..]]

type DivideConquer a b = (a->Bool)->(a->b)->(a->[a])->([b]->b)->a->b

dc:: DivideConquer a b
dc trivial solve split combine x = case (trivial x) of
    False -> combine (map (dc trivial solve split combine) (split x))
    True -> solve x

mergeSort:: Ord a => [a]->[a]
mergeSort xs = dc trivial id split combine xs
    where trivial xs = if length(xs) == 1 then True else False
          split xs = [take (quot (length(xs)) 2) xs,drop (quot (length(xs)) 2) xs]
          combine xs = concat (combinar (xs!!0) (xs!!1))


combinar::Ord a =>[a]->[a]->[[a]]
combinar xs ys = [(filter (entre ys i) xs) ++ [ys!!i]| i<-[0..length(ys)-1]]
    where entre ys i x = if i==0 then (x < ys!!i) else (x < ys!!i) && (x > ys!!(i-1))


mapdc::(a->b)->[a]->[b]
mapdc f [] = []
mapdc f xs = dc trivial solve split combine xs
    where trivial xs = (length(xs) == 1)
          solve xs = [f (xs!!0)]
          split xs = [take (quot (length(xs)) 2) xs,drop (quot (length(xs)) 2) xs]
          combine xs = xs!!0 ++ xs!!1


filterdc::(a->Bool)->[a]->[a]
filterdc f [] = []
filterdc f l = dc trivial solve split combine l
    where trivial xs = (length(xs) == 1)
          solve xs = if (f (xs!!0)) then [(xs!!0)] else []
          split xs = [take (quot (length(xs)) 2) xs,drop (quot (length(xs)) 2) xs]
          combine xs = xs!!0 ++ xs!!1


sumar::Num a => [a]->a
sumar = foldr (+) 0

elemm:: Eq a => a->[a]->Bool
elemm e = foldr (\x y-> y || (x == e)) False

mejorSegun::(a->a->Bool)->[a]->a
mejorSegun f l = foldr1 (\x y->if (f x y) then x else y) l

sumAlt::Num a => [a]->a
sumAlt l = foldr func (const 0) l True
    where func x g b = if b then (g False)+x else  (g True)-x

sumAltInv::Num a => [a]->a
sumAltInv l = foldr func (const 0) l ((mod (length(l)) 2) /= 0)
    where func x g b = if b then (g False)+x else  (g True)-x


permutaciones::Eq a =>[a]->[[a]]
permutaciones xs = unique (foldr func [] xs)
    where func x res = [ (take i (delete x xs)) ++ [x] ++ (drop i (delete x xs)) | i<-[0..length(xs)]] ++ res


delete:: Eq a => a->[a]->[a]
delete x xs = filter (\v-> v/=x) xs

unique::Eq a => [a]->[a]
unique = foldr (\x l-> if elem x l then l else x:l) []



partes::[a]->[[a]]
partes = foldr func [[]]
    where func x xs = xs ++ (map (\l->(x:l)) xs)

prefijos::[a]->[[a]]
prefijos xs = [take i xs | i<-[0..length(xs)]]


sublistas::Eq a => [a]->[[a]]
sublistas xs = unique ([take i (drop j xs) | i<-[0..length(xs)], j<-[0..length(xs)]])


recr::(a->[a]->b->b)->b->[a]->b
recr f z [] = z
recr f z (x:xs) = f x xs (recr f z xs)

sacarUna::Eq a => a->[a]->[a]
sacarUna x xs = recr func [] xs
    where func val xs res = if (val == x && elem val res) then res else val:res


genLista::a->(a->a)->Int->[a]
genLista inicial f cant = take cant (iterate f inicial)

desdeHasta::Int->Int->[Int]
desdeHasta a b = genLista a (+1) (b-a+1)


mapPares::(a->b->c)->[(a,b)]->[c]
mapPares f l = map (uncurry f) l

{-
armarPares::[a]->[b]->[(a,b)]
armarPares xs ys = map (map (\x->(\y->(x,y))) ) ys xs
-}

{-
armarPares::[a]->[b]->[(a,b)]
armarPares xs ys = map (\x->map (\y->(x,y)) ys ) xs
-}


armarPares::[a]->[b]->[(a,b)]
armarPares xs ys = undefined


mapDoble::(a->b->c)->[a]->[b]->[c]
mapDoble f l1 l2 = mapPares f (armarPares l1 l2)

sumaListas::[Int]->[Int]->[Int]
sumaListas xs ys = zipWith (+) xs ys

sumaMat::[[Int]]->[[Int]]->[[Int]]
sumaMat xs ys = zipWith sumaListas xs ys

transponer::[[Int]]->[[Int]]
transponer [] = []
transponer xs = [ [((xs!!j)!!i) |j<-[0..length(xs)-1]] | i<-[0..length(xs!!0)-1]]


generate :: ([a] -> Bool) -> ([a] -> a) -> [a]
generate stop next = generateFrom stop next []

generateFrom:: ([a] -> Bool) -> ([a] -> a) -> [a] -> [a]
generateFrom stop next xs | stop xs = init xs
                          | otherwise = generateFrom stop next (xs ++ [next xs])



generateBase::([a]->Bool)->a->(a->a)->[a]
generateBase stop inicial next = generate stop func
    where func [] = inicial
          func xs = next (last xs)


factoriales::Int->[Int]
factoriales n = generate (\xs->length(xs) == n+1) func
    where func [] = 1
          func xs = (length(xs)+1) * (last xs)


iterateN::Int->(a->a)->a->[a]
iterateN n func inicial = generateBase (\xs-> length(xs) == n+1) inicial func



foldNat::(Int->b->b)->b->Int->b
foldNat f z 0 = z
foldNat f z n = f n (foldNat f z (n-1)) 


potencia::Int->Int->Int
potencia x = foldNat (\e res-> res*x) 1




data Polinomio a = X
                 | Cte a
                 | Suma (Polinomio a) (Polinomio a)
                 | Prod (Polinomio a) (Polinomio a)


foldPol::b->(a->b)->(b->b->b)->(b->b->b)->Polinomio a->b
foldPol xF cteF sumF prodF pol = case pol of
    X -> xF
    Cte e -> cteF e 
    Suma pol1 pol2 -> sumF (recu pol1) (recu pol2)
    Prod pol1 pol2 -> prodF (recu pol1) (recu pol2)
    where recu polinom = foldPol xF cteF sumF prodF polinom


evaluar::Num a => a->Polinomio a->a
evaluar e pol = foldPol e id (+) (*) pol



--------------------


soloPuntosFijos :: [Int -> Int] -> Int -> [Int -> Int]
soloPuntosFijos functions n = filter (\e -> e n == n) functions




longitud :: [a]->Int
longitud = foldr (\e sum->sum+1) 0

concatenar :: [[a]]->[a]
concatenar xs = foldr (\e list-> e++list) [] xs 

foldr2 :: (a->b->b)->b->[a]->b
foldr2 _ z [] = z
foldr2 f z (x:xs) = f x (foldr2 f z xs)


take2 :: Int->[a]->[a]
take2 n xs = foldr step (const []) xs n
    where step e g 0 = []
          step e g n = e : (g (n-1)) 



--------------- parciales

type MatrizInfinita a = Int->Int->a


fila::Int->MatrizInfinita a->[a]
fila n matrix = [ (matrix n i) | i<-[0..] ]

columna::Int->MatrizInfinita a->[a]
columna n matrix = [ (matrix i n) | i<-[0..] ]


transponerM::MatrizInfinita a->MatrizInfinita a
transponerM matrix = (\x y->matrix y x)


mapMatriz::(a->b)->MatrizInfinita a->MatrizInfinita b
mapMatriz f matrix = (\x y -> f (matrix x y))



type Nat = Int
type Multiconj a = a -> Nat


union :: Multiconj a -> Multiconj a -> Multiconj a
union c1 c2 = (\e -> (c1 e)+ (c2 e))


interseccion :: Multiconj a -> Multiconj a -> Multiconj a
interseccion c1 c2 = (\e -> min (c1 e) (c2 e))


mMul ::  Multiconj Nat
mMul = const 1

factorizacion :: Nat -> Multiconj Nat
factorizacion n = (\e -> vecesQueDivide e n)

vecesQueDivide :: Nat -> Nat -> Nat
vecesQueDivide e n = 0


minMC :: Multiconj Nat -> Nat
minMC c = head [i | i<-[0..], c i > 0]





data Calendario = Vacıo | Eventos Fecha [String] Calendario
type Fecha = String


foldCalendario :: (Fecha->[String]->b->b)->b->Calendario->b
foldCalendario funcEvento casoBase cal = case cal of
           Vacıo -> casoBase
           Eventos f e c -> funcEvento f e (foldCalendario funcEvento casoBase c)


eventosDeFecha :: Fecha -> Calendario -> [String]
eventosDeFecha fecha cal = foldCalendario (\f e rec -> if f == fecha then e ++ rec else rec) [] cal






























