import tensorflow as tf
import larq as lq
import numpy as np

(train_images, train_labels), (test_images, test_labels) = tf.keras.datasets.mnist.load_data()

train_images = train_images.reshape((60000, 28, 28, 1))
test_images = test_images.reshape((10000, 28, 28, 1))

# Normalize pixel values to be between -1 and 1
train_images, test_images = 2 *np.ceil(train_images / 255) - 1, 2 * np.ceil(test_images / 255) -1

#train_images = (train_images > 127).astype(np.int32)
#test_images  = (test_images  > 127).astype(np.int32)

# print(test_images[120].reshape(28,28))

kwargs = dict(
    input_quantizer="ste_sign",
    kernel_quantizer="ste_sign",
    kernel_constraint="weight_clip"
)

model = tf.keras.models.Sequential()

# In the first layer we only quantize the weights and not the input
model.add(lq.layers.QuantConv2D(64, (1, 1),
                                kernel_quantizer="ste_sign",
                                kernel_constraint="weight_clip",
                                use_bias=False,
                                input_shape=(28, 28, 1)))
model.add(lq.layers.QuantConv2D(32, (1, 1), use_bias=False, **kwargs))
model.add(tf.keras.layers.Flatten())
model.add(lq.layers.QuantDense(10, use_bias=False, **kwargs))
model.add(tf.keras.layers.Activation("softmax"))
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

model.fit(train_images, train_labels, batch_size=64, epochs=6)
test_loss, test_acc = model.evaluate(test_images, test_labels)

print(f"Test accuracy {test_acc * 100:.2f} %")

# this one achived 84.55% acc
