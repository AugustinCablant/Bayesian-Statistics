import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.decomposition import PCA
from sklearn.neighbors import KernelDensity

def plot_credibleball(x, data, dx=None, xgrid=None, dxgrid=None):
    if data is None or not isinstance(data, pd.DataFrame):
        raise ValueError("`data` must be a supplied pandas DataFrame.")

    p = data.shape[1]
    n = data.shape[0]

    k_u = np.max(x['c_uppervert'], axis=1)
    n_u = x['c_uppervert'].shape[0]

    k_l = np.max(x['c_lowervert'], axis=1)
    n_l = x['c_lowervert'].shape[0]

    k_h = np.max(x['c_horiz'], axis=1)
    n_h = x['c_horiz'].shape[0]

    plt.ion()  # Interactive mode for sequential plots

    if p == 1:
        x1 = data.iloc[:, 0]

        # Compute density grid if not provided
        if dxgrid is None:
            if xgrid is None:
                xgrid = np.linspace(x1.min(), x1.max(), 100)
            kde = KernelDensity(kernel='gaussian', bandwidth=0.2).fit(x1.values.reshape(-1, 1))
            dxgrid = np.exp(kde.score_samples(xgrid.reshape(-1, 1)))

        # Compute density at data points
        if dx is None:
            kde = KernelDensity(kernel='gaussian', bandwidth=0.2).fit(x1.values.reshape(-1, 1))
            dx = np.exp(kde.score_samples(x1.values.reshape(-1, 1)))

        # Upper bound
        colors = sns.color_palette("rainbow", int(k_u.max()))
        for i in range(n_u):
            plt.figure()
            plt.plot(xgrid, dxgrid, label="Density")
            plt.title("Credible Ball: Upper Vertical Bound")
            plt.xlabel(data.columns[0])
            plt.ylabel("Density")
            for j in range(1, int(k_u.max()) + 1):
                plt.scatter(x1[x['c_uppervert'][i, :] == j], dx[x['c_uppervert'][i, :] == j], color=colors[j - 1], label=f"Cluster {j}")
            plt.legend()
            plt.show()

        # Lower bound
        colors = sns.color_palette("rainbow", int(k_l.max()))
        for i in range(n_l):
            plt.figure()
            plt.plot(xgrid, dxgrid, label="Density")
            plt.title("Credible Ball: Lower Vertical Bound")
            plt.xlabel(data.columns[0])
            plt.ylabel("Density")
            for j in range(1, int(k_l.max()) + 1):
                plt.scatter(x1[x['c_lowervert'][i, :] == j], dx[x['c_lowervert'][i, :] == j], color=colors[j - 1], label=f"Cluster {j}")
            plt.legend()
            plt.show()

        # Horizontal bound
        colors = sns.color_palette("rainbow", int(k_h.max()))
        for i in range(n_h):
            plt.figure()
            plt.plot(xgrid, dxgrid, label="Density")
            plt.title("Credible Ball: Horizontal Bound")
            plt.xlabel(data.columns[0])
            plt.ylabel("Density")
            for j in range(1, int(k_h.max()) + 1):
                plt.scatter(x1[x['c_horiz'][i, :] == j], dx[x['c_horiz'][i, :] == j], color=colors[j - 1], label=f"Cluster {j}")
            plt.legend()
            plt.show()

    elif p == 2:
        x1, x2 = data.iloc[:, 0], data.iloc[:, 1]

        # Upper bound
        colors = sns.color_palette("rainbow", int(k_u.max()))
        for i in range(n_u):
            plt.figure()
            plt.scatter(x1, x2, alpha=0.3, label="Data")
            plt.title("Credible Ball: Upper Vertical Bound")
            plt.xlabel(data.columns[0])
            plt.ylabel(data.columns[1])
            for j in range(1, int(k_u.max()) + 1):
                plt.scatter(x1[x['c_uppervert'][i, :] == j], x2[x['c_uppervert'][i, :] == j], color=colors[j - 1], label=f"Cluster {j}")
            plt.legend()
            plt.show()

        # Lower bound
        colors = sns.color_palette("rainbow", int(k_l.max()))
        for i in range(n_l):
            plt.figure()
            plt.scatter(x1, x2, alpha=0.3, label="Data")
            plt.title("Credible Ball: Lower Vertical Bound")
            plt.xlabel(data.columns[0])
            plt.ylabel(data.columns[1])
            for j in range(1, int(k_l.max()) + 1):
                plt.scatter(x1[x['c_lowervert'][i, :] == j], x2[x['c_lowervert'][i, :] == j], color=colors[j - 1], label=f"Cluster {j}")
            plt.legend()
            plt.show()

        # Horizontal bound
        colors = sns.color_palette("rainbow", int(k_h.max()))
        for i in range(n_h):
            plt.figure()
            plt.scatter(x1, x2, alpha=0.3, label="Data")
            plt.title("Credible Ball: Horizontal Bound")
            plt.xlabel(data.columns[0])
            plt.ylabel(data.columns[1])
            for j in range(1, int(k_h.max()) + 1):
                plt.scatter(x1[x['c_horiz'][i, :] == j], x2[x['c_horiz'][i, :] == j], color=colors[j - 1], label=f"Cluster {j}")
            plt.legend()
            plt.show()

    else:
        # PCA for higher-dimensional data
        pca = PCA(n_components=2)
        principal_components = pca.fit_transform(data)
        x1, x2 = principal_components[:, 0], principal_components[:, 1]

        # Upper bound
        colors = sns.color_palette("rainbow", int(k_u.max()))
        for i in range(n_u):
            plt.figure()
            plt.scatter(x1, x2, alpha=0.3, label="Data")
            plt.title("Credible Ball: Upper Vertical Bound (PCA)")
            plt.xlabel("PC1")
            plt.ylabel("PC2")
            for j in range(1, int(k_u.max()) + 1):
                plt.scatter(x1[x['c_uppervert'][i, :] == j], x2[x['c_uppervert'][i, :] == j], color=colors[j - 1], label=f"Cluster {j}")
            plt.legend()
            plt.show()

        # Lower and Horizontal bounds follow the same structure.

    plt.ioff()  # Turn off interactive mode after plotting
