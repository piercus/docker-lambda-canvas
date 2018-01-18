#/!bin/bash

cat steps/step_0_from_amazon_linux steps/step_1_install_canvas steps/step_2_move_lib > Dockerfile.default

cat steps/step_0_from_lambda_opencv steps/step_1_install_canvas steps/step_2_move_lib > Dockerfile.opencv