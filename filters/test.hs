double x = x + x

quadruple x = double $ double x

factorial n = product [1..n]

average ns = sum ns `div` length ns

n = a `div` length xs
    where
        a = 15
        xs = [1..7]

final [] = []
final (x:xs) = final xs
