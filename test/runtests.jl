using YaoPlots
using Test

plot(chain(X, H, X, H); figsize=(15cm, 1cm), fontsize=8)
plot(chain(kron(4, 1=>X, 3=>X), kron(4, 2=>X, 4=>X), kron(4, 1=>X, 4=>X)); figsize=(5cm, 10cm), fontsize=8)
