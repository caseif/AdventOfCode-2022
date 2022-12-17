(defconstant PART_A_ROW 2000000)
(defconstant PART_A_MIN 0)
(defconstant PART_A_MAX 4000000)

(defun curry (fn &rest args)
  (lambda (&rest remaining-args)
    (apply fn (append args remaining-args))))

(defun explode (str)
  (loop for i = 0 then (1+ j)
    as j = (position #\Space str :start i)
    collect (subseq str i j)
    while j))

(defun process-line (line)
  (mapcar #'parse-integer
    (mapcar (curry #'string-trim "xy=:,")
      (mapcar (lambda (i) (nth i (explode line)))
        '(2 3 8 9)))))

(defun manhattan-dist (coords)
  (+ (abs (- (first coords) (third coords)))
    (abs (- (second coords) (fourth coords)))))

(defun hor-rad-at-row (coords row)
  (max
    (+
      (*
        (-
          (manhattan-dist coords)
          (abs (-
            row
            (second coords))))
        2)
      1)
    0))

(defun collapse-ranges (ranges)
  (if (cdr ranges)
    (if (>= (cdar ranges) (caadr ranges))
      (collapse-ranges (cons (cons (caar ranges) (max (cdar ranges) (cdadr ranges))) (cddr ranges)))
      (cons (car ranges) (collapse-ranges (cdr ranges))))
    ranges))

(defun range-at-row (row coords)
  (setq r (hor-rad-at-row coords row))
  (if (/= r 0)
    (cons
      (- (car coords)
        (/ (max (- r 1) 0) 2))
      (+ (car coords)
        (/ (max (- r 1) 0) 2)))
    nil))

(defun get-ranges (all-coords row)
  (collapse-ranges
    (sort
      (remove nil
        (mapcar (curry #'range-at-row row) all-coords))
      #'<= :key #'car)))

(defun get-excluded-cols (ranges coords row)
  (remove-duplicates (if ranges
    (progn
      (setq match (find-if
        (lambda (c)
          (find-if
            (lambda (r) (and (= (fourth c) row) (and (>= (third c) (car r)) (<= (third c) (cdr r)))))
            ranges))
        coords))
      (if match
        (cons (third match) (get-excluded-cols ranges (cdr coords) row))
        (get-excluded-cols (cdr ranges) coords row)))
    nil)))

(defun sum-ranges (ranges)
  (if ranges
    (+ (+ (- (cdar ranges) (caar ranges)) (sum-ranges (cdr ranges)) 1))
    0))

(defun compute-part-a (coords)
  (setq ranges (get-ranges coords PART_A_ROW))
  (- (sum-ranges ranges)
    (length (get-excluded-cols ranges coords PART_A_ROW))))

(defun compute-part-b (coords)
  (loop named outer for n from PART_A_MIN to PART_A_MAX do
    (setq ranges (get-ranges coords n))
    (loop for r in ranges do
      (if (> (car r) PART_A_MIN)
        (return-from outer (+ (* (- (car r) 1) 4000000) n))
        (if (< (cdr r) PART_A_MAX)
          (return-from outer (+ (* (+ (cdr r) 1) 4000000) n)))))))

(setq lines (with-open-file (stream "input.txt")
  (loop for line = (read-line stream nil)
    while line
    collect line)))

(setq coords (mapcar #'process-line lines))
(format t "Part A: ~d~%" (compute-part-a coords))
(format t "Part B: ~d~%" (compute-part-b coords))
