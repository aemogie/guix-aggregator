(use-modules (guix profiles)
             (gnu packages python)
             (gnu packages qt)
             (gnu packages jupyter)
             (gnu packages python-xyz)
             (gnu packages machine-learning)
             (gnu packages python-science))

(packages->manifest
  (list python
        python-ipython
        python-numpy
        python-pandas
        python-matplotlib
        python-seaborn
        python-tabulate
        python-scikit-learn
        python-scipy
        python-jupyterlab-server
        jupyter
        python-pyqt
        python-lsp-server))
