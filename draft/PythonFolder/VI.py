import numpy as np

def compute_VI(cls, cls_draw):
    """
    Computes the posterior expected Variation of Information (VI).

    Parameters:
    ----------
    cls : array-like, shape (1, n) or (n,)
        A single clustering configuration (vector or single-row matrix).
    cls_draw : array-like, shape (M, n)
        Matrix of M clustering samples, each with n elements.

    Returns:
    -------
    numpy.ndarray
        An array containing the VI for each row of `cls`.
    """
    # Ensure cls is a 2D array for consistent computation
    cls = np.atleast_2d(cls)
    n = cls_draw.shape[1]
    M = cls_draw.shape[0]

    def vi_compute(c):
        f = 0
        for i in range(n):
            ind = (c == c[i])  # Indicator for cls
            f += np.log2(np.sum(ind))
            for m in range(M):
                ind_m = (cls_draw[m, :] == cls_draw[m, i])  # Indicator for cls_draw
                intersection = ind & ind_m
                f += (np.log2(np.sum(ind_m)) - 2 * np.log2(np.sum(intersection))) / M
        f /= n
        return f

    # Apply VI computation for each row of cls
    output = np.apply_along_axis(vi_compute, 1, cls)
    return output

def compute_VI_lb(cls, psm):
    """
    Computes the lower bound to the posterior expected Variation of Information (VI).

    Parameters:
    ----------
    cls : array-like, shape (1, n) or (n,)
        A single clustering configuration (vector or single-row matrix).
    psm : numpy.ndarray, shape (n, n)
        Pairwise Similarity Matrix (PSM). Must be symmetric, have entries between 0 and 1, 
        and have 1's on the diagonal.

    Returns:
    -------
    numpy.ndarray
        An array containing the lower bound to the VI for each row of `cls`.

    Raises:
    ------
    ValueError
        If `psm` is not symmetric, has values outside [0, 1], or does not have 1's on the diagonal.
    """
    # Validation of the Pairwise Similarity Matrix (PSM)
    if not (np.allclose(psm, psm.T) and np.all((psm >= 0) & (psm <= 1)) and np.all(np.diag(psm) == 1)):
        raise ValueError("psm must be a symmetric matrix with entries between 0 and 1 and 1's on the diagonals.")

    # Ensure cls is a 2D array for consistent computation
    cls = np.atleast_2d(cls)
    n = psm.shape[0]

    def vi_lb_compute(c):
        f = 0
        for i in range(n):
            ind = (c == c[i])  # Indicator for cls
            f += (np.log2(np.sum(ind)) +
                  np.log2(np.sum(psm[i, :])) -
                  2 * np.log2(np.sum(ind * psm[i, :]))) / n
        return f

    # Apply VI.lb computation for each row of cls
    output = np.apply_along_axis(vi_lb_compute, 1, cls)
    return output
