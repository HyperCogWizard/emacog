;;; org-chatbot-example.el --- Example usage of Org-Mode Chatbot Interface

;; This file demonstrates the Org-Mode and Elisp Chatbot Interface
;; functionality with practical examples.

;;; Commentary:

;; Load this file and run the examples to see the chatbot in action.
;; Make sure org-chatbot.el is in your load path.

;;; Code:

(require 'org-chatbot)

(defun org-chatbot-example-basic-session ()
  "Demonstrate basic chatbot session functionality."
  (interactive)
  (message "Starting basic chatbot example...")
  
  ;; Start a new session
  (org-chatbot-start-session "example-basic")
  
  ;; Send some example messages programmatically
  (org-chatbot-send-message "Hello, what can you help me with?")
  (org-chatbot-send-message "This is urgent - I need help with cognitive processing")
  (org-chatbot-send-message "Can you explain the hypergraph architecture?")
  
  ;; Show the attention map
  (org-chatbot-show-attention-map)
  
  (message "Basic example complete. Check the *Org Chatbot* buffer."))

(defun org-chatbot-example-technical-session ()
  "Demonstrate technical domain conversation."
  (interactive)
  (message "Starting technical chatbot example...")
  
  ;; Start a new session
  (org-chatbot-start-session "example-technical")
  
  ;; Technical conversation
  (org-chatbot-send-message "I need help with elisp programming")
  (org-chatbot-send-message "How do I integrate with org mode features?")
  (org-chatbot-send-message "What emacs functions should I use?")
  
  ;; Export the session
  (let ((filename (org-chatbot-export-session)))
    (message "Technical session exported to: %s" filename)))

(defun org-chatbot-example-cognitive-session ()
  "Demonstrate cognitive domain conversation."
  (interactive)
  (message "Starting cognitive chatbot example...")
  
  ;; Start a new session
  (org-chatbot-start-session "example-cognitive")
  
  ;; Cognitive conversation
  (org-chatbot-send-message "Explain the cognitive architecture patterns")
  (org-chatbot-send-message "How does attention allocation work?")
  (org-chatbot-send-message "What are hypergraph semantic networks?")
  
  ;; Show attention map for cognitive topics
  (org-chatbot-show-attention-map)
  
  (message "Cognitive example complete."))

(defun org-chatbot-example-mixed-priority ()
  "Demonstrate mixed priority conversation with attention shifting."
  (interactive)
  (message "Starting mixed priority example...")
  
  ;; Start a new session
  (org-chatbot-start-session "example-mixed")
  
  ;; Mixed conversation with different priorities
  (org-chatbot-send-message "Normal question about features")
  (org-chatbot-send-message "URGENT: Critical system issue needs attention")
  (org-chatbot-send-message "What is the cognitive processing approach?")
  (org-chatbot-send-message "How can I help with elisp development?")
  
  ;; Export and show attention evolution
  (org-chatbot-export-session)
  (org-chatbot-show-attention-map)
  
  (message "Mixed priority example complete."))

(defun org-chatbot-run-all-examples ()
  "Run all chatbot examples in sequence."
  (interactive)
  (message "Running all chatbot examples...")
  
  (org-chatbot-example-basic-session)
  (sit-for 2)
  
  (org-chatbot-example-technical-session)
  (sit-for 2)
  
  (org-chatbot-example-cognitive-session)
  (sit-for 2)
  
  (org-chatbot-example-mixed-priority)
  
  (message "All examples completed!"))

;;; Interactive Example Session

(defun org-chatbot-interactive-demo ()
  "Start an interactive demo session with guided prompts."
  (interactive)
  (org-chatbot-start-session "interactive-demo")
  
  (with-current-buffer (get-buffer org-chatbot-buffer-name)
    (goto-char (point-max))
    (insert "\n** Interactive Demo Guide\n\n")
    (insert "Try these example commands:\n\n")
    (insert "- M-x org-chatbot-send-message \"urgent help needed\"\n")
    (insert "- M-x org-chatbot-send-message \"what is cognitive processing?\"\n")
    (insert "- M-x org-chatbot-send-message \"explain elisp programming\"\n")
    (insert "- M-x org-chatbot-show-attention-map\n")
    (insert "- M-x org-chatbot-export-session\n\n")
    (insert "Each message will demonstrate different response patterns\n")
    (insert "based on semantic content and attention allocation.\n\n"))
  
  (message "Interactive demo started. Follow the guide in the buffer."))

(provide 'org-chatbot-example)

;;; org-chatbot-example.el ends here