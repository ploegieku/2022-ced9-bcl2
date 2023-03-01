SCALED=1

for KSIZE in $(seq 5 1 30); do
  for ALPHABET in hp dayhoff; do
    SUFFIX=singleton.$ALPHABET.k$KSIZE.scaled$SCALED

    for FASTA in *fasta ; do
      SIG=$FASTA.$SUFFIX.sig
      CSV=$FASTA.$SUFFIX.describe.csv
      KMERS=$FASTA.$SUFFIX.kmers.csv
      sourmash sketch protein \
          --output $SIG \
          --singleton \
          --$ALPHABET \
          --force \
          -p k=$KSIZE,scaled=$SCALED,abund \
          $FASTA
      sourmash sig describe \
          --csv $CSV \
          --quiet \
          $SIG
      python sig2kmer.py \
        --output-kmers $KMERS \
        --input-is-protein \
        --ksize $KSIZE \
        --$ALPHABET \
        --no-dna \
        $SIG $FASTA
    done
    CED9=ced9*$SUFFIX.sig
    BCL2=bcl2*$SUFFIX.sig

    echo "CED9" $CED9
    echo "BCL2" $BCL2
    sourmash sig overlap \
      $CED9 $BCL2 > sig_overlap_$SUFFIX.txt

  done
done