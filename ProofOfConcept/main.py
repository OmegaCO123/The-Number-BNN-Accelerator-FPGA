import numpy as np

conv1Weights = np.loadtxt("replaceW-1.txt", dtype=int) # 1 x 64
conv2Weights = np.loadtxt("replaceW-2.txt", dtype=int) # 64 x 32
denseWeights = np.loadtxt("replaceW-3.txt", dtype=int) # 25088 x 10
image7 = np.loadtxt("image.txt", dtype=int) # 28 x 28



def sign(x):
    """Binarize activations and weights to ±1.""" # [0,1,-1]
    return np.where(x >= 0, 1, -1)

def conv2d_1x1(x, w):
    """
    1x1 convolution (binary): x shape (H, W, Cin), w shape (1, 1, Cin, Cout)
    Output shape: (H, W, Cout)
    """
    #H, W, Cin = x.shape 
    #Cout = w.shape[-1]
    # Since kernel = 1x1, it’s just per-pixel matrix multiplication
    #x_flat = x.reshape(-1, Cin)          # (H*W, Cin) - 784 x 64
    #w_flat = w.reshape(Cin, Cout)        # (Cin, Cout) 64 x 32
    y = np.dot(x, w)           # Matrix Mult => 784 x 32
    return y     #.reshape(Cin,Cout)    # 28 x 28 x 32

def dense(x, w):
    """Fully connected binary layer."""
    return np.dot(x, w)

# ---------- Network setup ----------

# image7 = sign(image7)

#image7 = image7.flatten() # 1 x 784

print(conv1Weights.shape)

print(image7.reshape(784,1).shape)

# Layer 1
x = conv2d_1x1(image7.reshape(784, 1), conv1Weights.reshape(1,64)) # 784 x 1 . 1 x 64 => 784 x 64 -> 28 x 28 x 64
x = sign(x) # => 28 x 28 x 64 of [-1,1].

# Layer 2
x = conv2d_1x1(x, conv2Weights) # 28 x 28 x 64 . 64 x 32 => (28*28*32,) => 28 x 28 x 32
x = sign(x) # (28*28*32,) => 28 x 28 x 32 of [-1,1]

# Flatten for dense layer
x_flat = x.reshape(-1)  # 28 x 28 x 32 to 1 x 25088

# Dense layer
out = dense(x_flat, denseWeights) # 1 x 25088 . 25088 x 10 => 1 x 10

print("Output logits:", out)
print("Predicted class:", np.argmax(out))

def popcount_before(arr):
    sum =0
    for i in arr:
        sum+= i
    return 2*sum - len(arr)



def xnor_popcount_before(x,w):
    y = np.array().reshape(x.shape[0],w.shape[1])


    for r in range(0,x.shape[0]):
        for c in range(0,w.shape[1]):
            y[r][c] = popcount_before(np.logical_not(np.logical_xor(x[r],np.transpose(w)[c])))

    return y


def activations(x):
    return np.where(x >= 0, 1, -1) 


