import matplotlib.pyplot as plt
import numpy as np
import os
# 숙제 - 한번 해보기

# file dialog를 통해 파일이 무슨 꽃인지 종류를 예측하는 프로그램
# 주소라인, 버튼
# 불러온 이미지 표시
# 텍스트 상자 (Print로 나온 결과들 표시)

import PIL
import tensorflow as tf

from tensorflow import keras

model = tf.keras.models.load_model('./sample_model.h5')

class_names = ['daisy', 'dandelion', 'roses', 'sunflowers', 'tulips']
img_height = 180
img_width = 180

sunflower_url = "https://storage.googleapis.com/download.tensorflow.org/example_images/592px-Red_sunflower.jpg"
sunflower_path = tf.keras.utils.get_file('Red_sunflower', origin=sunflower_url)
img = keras.preprocessing.image.load_img(
    sunflower_path, target_size=(img_height, img_width)
)

img_array = keras.preprocessing.image.img_to_array(img)
img_array = tf.expand_dims(img_array, 0) # Create a batch

predictions = model.predict(img_array)
score = tf.nn.softmax(predictions[0])

plt.imshow(img)
plt.axis('off')
plt.show()
print(score)
print(class_names[np.argmax(score)])
print(f"{100 * np.max(score):0.2f}%")
