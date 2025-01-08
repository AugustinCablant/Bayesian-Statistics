import numpy as np
import pandas as pd
from typing import Literal

def calculate_credible_ball(c_star, cls_draw, c_dist="VI", alpha=0.05):
    """
    Calculate the Credible Ball for clustering analysis.

    Parameters:
    ----------
    c_star : array-like
        The optimal clustering configuration.
    cls_draw : array-like, shape (M, n)
        Matrix of M clustering samples, each with n elements.
    c_dist : str, optional
        The distance metric to use: "VI" (Variation of Information) or "Binder". Default is "VI".
    alpha : float, optional
        Credible level (1 - alpha). Default is 0.05.

    Returns:
    -------
    dict
        A dictionary containing the following keys:
        - c_star : The optimal clustering configuration.
        - c_horiz : Horizontal extreme of the credible ball.
        - c_uppervert : Upper vertical extreme of the credible ball.
        - c_lowervert : Lower vertical extreme of the credible ball.
        - dist_horiz : Distance of the horizontal extreme.
        - dist_uppervert : Distance of the upper vertical extreme.
        - dist_lowervert : Distance of the lower vertical extreme.
    """
    n = len(c_star)
    
    # Distance functions
    def dist_binder(c1, c2):
        f = 0
        for i in range(n):
            f += np.sum(np.abs((c1 == c1[i]) - (c2 == c2[i])))
        f /= n ** 2
        return f

    def dist_vi(c1, c2):
        f = 0
        for i in range(n):
            ind1 = (c1 == c1[i])
            ind2 = (c2 == c2[i])
            f += (np.log2(np.sum(ind1)) + np.log2(np.sum(ind2)) - 2 * np.log2(np.sum(ind1 & ind2))) / n
        return f
    
    # Validate distance metric
    if c_dist not in ["VI", "Binder"]:
        raise ValueError("Invalid c_dist value. Choose 'VI' or 'Binder'.")
    
    # Compute distances between optimal and samples
    M, _ = cls_draw.shape
    distances = np.zeros(M)
    
    if c_dist == "Binder":
        distances = np.array([dist_binder(c1, c_star) for c1 in cls_draw])
    elif c_dist == "VI":
        distances = np.array([dist_vi(c1, c_star) for c1 in cls_draw])
    
    sorted_indices = np.argsort(distances)
    ind_star = int(np.ceil((1 - alpha) * M))
    
    # Credible ball
    credible_ball_samples = cls_draw[sorted_indices[:ind_star]]
    credible_ball_distances = distances[sorted_indices[:ind_star]]
    
    # Extremes of credible ball
    horiz_extreme = credible_ball_samples[credible_ball_distances == credible_ball_distances[ind_star - 1]]
    max_clusters = credible_ball_samples.max(axis=1)
    
    min_ind = np.where(max_clusters == max_clusters.min())[0]
    upper_vert_extreme = credible_ball_samples[min_ind[credible_ball_distances[min_ind] == credible_ball_distances[min_ind[-1]]]]
    
    max_ind = np.where(max_clusters == max_clusters.max())[0]
    lower_vert_extreme = credible_ball_samples[max_ind[credible_ball_distances[max_ind] == credible_ball_distances[max_ind[-1]]]]
    
    return {
        "c_star": c_star,
        "c_horiz": horiz_extreme,
        "c_uppervert": upper_vert_extreme,
        "c_lowervert": lower_vert_extreme,
        "dist_horiz": credible_ball_distances[ind_star - 1],
        "dist_uppervert": credible_ball_distances[min_ind[-1]],
        "dist_lowervert": credible_ball_distances[max_ind[-1]]
    }
