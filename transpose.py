import csv
import glob
import os


def read_data(file):
    data = []
    with open(file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            row = line.strip().split()
            data.append([float(item) for item in row if item])
    return data


def transpose_3d(data):
    transposed = []
    for i in range(len(data[0])):  # number of samples
        transposed.append([])
        for j in range(len(data[0][0])):  # number of timesteps
            transposed[i].append([])
            for k in range(len(data)):  # number of signals
                transposed[i][j].append(data[k][i][j])
    return transposed


def build_data(subset):
    valid_subsets = ["train", "val", "test"]
    if subset not in valid_subsets:
        raise Exception(f"Invalid subset: {subset}")

    folder_path = f"UCI_HAR_Dataset/UCI_HAR_Dataset/{subset}/Inertial Signals/"

    # Get all signal files in folder
    signal_files = glob.glob(os.path.join(folder_path, "*.txt"))
    num_signal_files = len(signal_files)
    assert num_signal_files == 9, f"No signal files found in {folder_path}"

    # Determine signal order based on file names
    signal_order = [
        "body_acc_x_",
        "body_acc_y_",
        "body_acc_z_",
        "body_gyro_x_",
        "body_gyro_y_",
        "body_gyro_z_",
        "total_acc_x_",
        "total_acc_y_",
        "total_acc_z_",
    ]

    signal_files = [
        f"UCI_HAR_Dataset/UCI_HAR_Dataset/{subset}/Inertial Signals/{x}{subset}.txt"
        for x in signal_order
    ]

    # Load signal data from each file and append to signals_data list
    signals_data = [read_data(x) for x in signal_files]

    # Sanity check
    num_samples = len(signals_data)
    num_timesteps = len(signals_data[0])
    num_signals = len(signals_data[0][0])
    print("Shape before transpose: ", num_samples, len(
        signals_data[0]), len(signals_data[0][0]))

    # Transpose signal data array so that shape is (number of samples, number of timesteps, number of signals)
    signals_data = transpose_3d(signals_data)

    # Determine number of samples, timesteps, and signals
    num_samples = len(signals_data)
    num_timesteps = len(signals_data[0])
    num_signals = len(signals_data[0][0])

    print("Shape after transpose: ", num_samples, num_timesteps, num_signals)

    # Verify final shape of combined data
    expected_shape = (7352, 128, num_signal_files) if subset == "train" else (
        2947, 128, num_signal_files)
    assert (num_samples, num_timesteps, num_signals) == expected_shape, \
        f"Instead of shape {expected_shape}, shape is actually {num_samples}, {num_timesteps}, {num_signals}"

    return signals_data


def load_y(subset):
    # Get the path
    path = f"UCI_HAR_Dataset/UCI_HAR_Dataset/{subset}/y_{subset}.txt"

    # Read the file
    with open(path, 'r') as file:
        y = [int(line) for line in file]

    # One-hot encode labels
    one_hot_labels = [[float(i == j) for i in range(1, 7)] for j in y]

    # Assertions
    if subset == "train":
        assert len(one_hot_labels) == 7352 and len(
            one_hot_labels[0]) == 6, f"Wrong dimensions: {len(one_hot_labels), len(one_hot_labels[0])} should be (7352, 6)"
    if subset == "test":
        assert len(one_hot_labels) == 2947 and len(
            one_hot_labels[0]) == 6, f"Wrong dimensions: {len(one_hot_labels), len(one_hot_labels[0])} should be (2947, 6)"
    assert (
        y[0] - 1 == [i for i, j in enumerate(one_hot_labels[0]) if j == 1.0][0]
    ), f"Value mismatch {[i for i, j in enumerate(one_hot_labels[0]) if j == 1.0][0]} vs {y[0] - 1}"

    return one_hot_labels


y_test = load_y("test")
print(y_test[0]) # [0.0, 0.0, 0.0, 0.0, 1.0, 0.0]
