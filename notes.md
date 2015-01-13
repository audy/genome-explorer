# Tue Jan 13 15:02:11 EST 2015

- Thinking about how to implement feature extraction:

  - I want to use SciKit Learn (Python) to implement all of the data-analysis
    stuff.

  - This should probably run as one or more microservices and communicate with
    the rails app through an API.

      - The biggest challenge is figuring out how to implement the API.

  - The API needs to accept:

    - List of genomes (and their categories)
    - List of features (and metadata)
    - Any parameters for the machine-learning/data-mining algorithms

    I think the best way to implement this part of the API is to just accept
    data in the most general format possible (i.e., don't accept a matrix of
    features and categories if it only works for one algorithm). That way, all
    of the algorithms can accept the same data (even if they don't use it, or
    use it differently).

    This data will then be converted into whatever format the algorithm needs. I
    think this will look like:

    ```
    API ->
      data (general) ->
        AlgorithmDataHandler ->
          data (reformatted) ->
            Algo
              -> output (heterogenous format)
    ```

    Example POST format to API:

    ```json
    {

      algorithm_parameters: {
        /* optional, used for feature selection */
        categories: [ [ 'genome_1', 'genome_2' ],
                      [ 'genome_3', 'genome_4' ] ]
      },

      genomes: {

        genome_id: {
          features: {
            feature_id: {
              /* metadata (start, stop, etc ...) */
            },
            /* ... */
          }
        },
        /* ... */

      }
    }
    ```

  - The API should return:

    - A list of features and associated statistics:

      - In the case where the algorithm is performing cross-validation for
        feature selection: AUC / Precision / Recall

      - In the case where the algorithm is performing cluster analysis:
        genome_id -> cluster_id (and also, perhaps a list of feature scores?)

      - In the case where the algorithm is returning dimension reduction: a list
        of coordinates?

      The format of the API's return is heterogenous and dependent on the
      algorithm / data analysis role. I guess this is okay since these will all
      have different views in the Rails app anyway. I don't think there is a way
      to generalize this.
