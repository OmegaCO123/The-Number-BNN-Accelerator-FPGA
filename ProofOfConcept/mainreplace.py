import numpy as np

R1Weights = np.loadtxt("replaceW-1.txt", dtype=int) # 1 x 64
R2Weights = np.loadtxt("replaceW-2.txt", dtype=int) # 64 x 32
R3Weights = np.loadtxt("replaceW-3.txt", dtype=int) # 25088 x 10
image = np.loadtxt("image8.txt", dtype=int) # 28 x 28

def printShape(x):
    print(x.shape) #

def popcount_before(arr):
    return 2 * np.sum(arr) - len(arr)

def xnor_popcount_before(x,w):
    y = np.zeros((x.shape[0], w.shape[1]), dtype=int)
    for r in range(0,x.shape[0]): 
        for c in range(0,w.shape[1]):
            y[r][c] = popcount_before(np.logical_not(np.logical_xor(x[r],np.transpose(w)[c])))
    return y

def activations(x):
    return np.where(x >= 0, 1, 0) 

#printShape(R1Weights)
#printShape(R2Weights)
#printShape(R3Weights)
#printShape(image)
# Layer 1
x = xnor_popcount_before(image.reshape(784, 1), R1Weights.reshape(1,64)) # 784 x 1 . 1 x 64 => 784 x 64 -> 28 x 28 x 64
x = activations(x) # => 28 x 28 x 64 of [-1,1].
#printShape(x)
# Layer 2
x = xnor_popcount_before(x, R2Weights) # 28 x 28 x 64 . 64 x 32 => (28*28*32,) => 28 x 28 x 32
x = activations(x) # (28*28*32,) => 28 x 28 x 32 of [-1,1]
#printShape(x)
# Flatten for dense layer
x_flat = x.reshape(1,25088)  # 28 x 28 x 32 to 1 x 25088
#printShape(x_flat)
# Dense layer
out = xnor_popcount_before(x_flat, R3Weights) # 1 x 25088 . 25088 x 10 => 1 x 10
#printShape(out)
print("Output logits:", out)
print("Predicted class:", np.argmax(out))


# hanlde matricies [64 by 32] [POC] -> implement somth
