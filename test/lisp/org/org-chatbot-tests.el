;;; org-chatbot-tests.el --- tests for org-chatbot.el  -*- lexical-binding:t -*-

;; Copyright (C) 2025 Free Software Foundation, Inc.

;; Maintainer: emacs-devel@gnu.org

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Tests for the Org-Mode and Elisp Chatbot Interface, validating:
;; - Message parsing and semantic analysis
;; - Hypergraph conversation memory structures
;; - Context-aware response generation
;; - Attention allocation mechanisms
;; - Org-mode integration and rendering

;;; Code:

(require 'ert)
(require 'org-chatbot)

;;; Test Data Structures

(ert-deftest org-chatbot-test-node-creation ()
  "Test creation of chatbot conversation nodes."
  (let ((node (org-chatbot--create-conversation-node "Test message")))
    (should (org-chatbot-node-p node))
    (should (string= (org-chatbot-node-content node) "Test message"))
    (should (org-chatbot-node-id node))
    (should (org-chatbot-node-timestamp node))
    (should (numberp (org-chatbot-node-attention-weight node)))
    (should (>= (org-chatbot-node-attention-weight node) 0.0))
    (should (<= (org-chatbot-node-attention-weight node) 1.0))))

(ert-deftest org-chatbot-test-context-creation ()
  "Test creation of conversation contexts."
  (let ((context (org-chatbot--create-context "test-context")))
    (should (org-chatbot-context-p context))
    (should (string= (org-chatbot-context-id context) "test-context"))
    (should (hash-table-p (org-chatbot-context-attention-map context)))
    (should (hash-table-p (org-chatbot-context-semantic-network context)))
    (should (listp (org-chatbot-context-active-nodes context)))
    (should (= (org-chatbot-context-recursive-depth context) 0))))

;;; Test Message Parsing

(ert-deftest org-chatbot-test-message-parsing-priority ()
  "Test message parsing with priority keywords."
  (let ((parsed (org-chatbot--parse-message "This is urgent and important")))
    (should (listp parsed))
    (should (member 'high-priority (plist-get parsed :tags)))
    (should (>= (plist-get parsed :attention-weight) 0.9))))

(ert-deftest org-chatbot-test-message-parsing-query ()
  "Test message parsing with query keywords."
  (let ((parsed (org-chatbot--parse-message "What is the question about help")))
    (should (member 'query (plist-get parsed :tags)))
    (should (>= (plist-get parsed :attention-weight) 0.7))))

(ert-deftest org-chatbot-test-message-parsing-cognitive ()
  "Test message parsing with cognitive domain keywords."
  (let ((parsed (org-chatbot--parse-message "cognitive hypergraph attention mechanisms")))
    (should (member 'cognitive-domain (plist-get parsed :tags)))
    (should (>= (plist-get parsed :attention-weight) 0.8))))

(ert-deftest org-chatbot-test-message-parsing-technical ()
  "Test message parsing with technical keywords."
  (let ((parsed (org-chatbot--parse-message "org mode elisp emacs development")))
    (should (member 'technical (plist-get parsed :tags)))
    (should (>= (plist-get parsed :attention-weight) 0.5))))

;;; Test Attention Allocation

(ert-deftest org-chatbot-test-attention-allocation ()
  "Test attention allocation mechanism updates."
  (let* ((context (org-chatbot--create-context "attention-test"))
         (node (org-chatbot--create-conversation-node "urgent cognitive question"))
         (updated-context (org-chatbot--update-attention-allocation context node))
         (attention-map (org-chatbot-context-attention-map updated-context)))
    
    (should (> (gethash 'high-priority attention-map 0.0) 0.0))
    (should (> (gethash 'cognitive-domain attention-map 0.0) 0.0))
    (should (> (gethash 'query attention-map 0.0) 0.0))))

(ert-deftest org-chatbot-test-attention-decay ()
  "Test attention decay mechanism over time."
  (let* ((context (org-chatbot--create-context "decay-test"))
         (attention-map (org-chatbot-context-attention-map context)))
    
    ;; Set initial high attention
    (puthash 'test-tag 0.9 attention-map)
    
    ;; Create node to trigger decay
    (let* ((node (org-chatbot--create-conversation-node "normal message"))
           (updated-context (org-chatbot--update-attention-allocation context node)))
      
      ;; Attention should decay for high-attention topics
      (should (< (gethash 'test-tag 
                          (org-chatbot-context-attention-map updated-context))
                 0.9)))))

;;; Test Response Generation

(ert-deftest org-chatbot-test-response-generation-priority ()
  "Test response generation for high priority messages."
  (let* ((context (org-chatbot--create-context "response-test"))
         (response (org-chatbot--generate-response "urgent help needed" context)))
    
    (should (stringp response))
    (should (string-match-p "priority\\|attention" response))))

(ert-deftest org-chatbot-test-response-generation-query ()
  "Test response generation for query messages."
  (let* ((context (org-chatbot--create-context "query-test"))
         (response (org-chatbot--generate-response "what is the question" context)))
    
    (should (stringp response))
    (should (string-match-p "question\\|knowledge" response))))

(ert-deftest org-chatbot-test-response-generation-cognitive ()
  "Test response generation for cognitive domain messages."
  (let* ((context (org-chatbot--create-context "cognitive-test"))
         (response (org-chatbot--generate-response "cognitive hypergraph patterns" context)))
    
    (should (stringp response))
    (should (string-match-p "cognitive\\|hypergraph\\|semantic" response))))

(ert-deftest org-chatbot-test-response-generation-technical ()
  "Test response generation for technical messages."
  (let* ((context (org-chatbot--create-context "technical-test"))
         (response (org-chatbot--generate-response "elisp org mode development" context)))
    
    (should (stringp response))
    (should (string-match-p "technical\\|Elisp\\|Org-mode" response))))

;;; Test Context Management

(ert-deftest org-chatbot-test-context-retrieval ()
  "Test context storage and retrieval mechanisms."
  (let* ((context-id "retrieval-test")
         (context1 (org-chatbot--get-or-create-context context-id))
         (context2 (org-chatbot--get-or-create-context context-id)))
    
    (should (eq context1 context2))
    (should (string= (org-chatbot-context-id context1) context-id))))

(ert-deftest org-chatbot-test-node-accumulation ()
  "Test that nodes accumulate properly in context."
  (let* ((context (org-chatbot--create-context "accumulation-test"))
         (initial-count (length (org-chatbot-context-active-nodes context))))
    
    ;; Generate responses to add nodes
    (org-chatbot--generate-response "first message" context)
    (should (= (length (org-chatbot-context-active-nodes context))
               (+ initial-count 2))) ; user message + response
    
    (org-chatbot--generate-response "second message" context)  
    (should (= (length (org-chatbot-context-active-nodes context))
               (+ initial-count 4))))) ; 2 messages + 2 responses

;;; Test Org-mode Integration

(ert-deftest org-chatbot-test-dialogue-tree-rendering ()
  "Test rendering of conversation as Org-mode structure."
  (let* ((context (org-chatbot--create-context "render-test")))
    
    ;; Add some conversation nodes
    (org-chatbot--generate-response "test message" context)
    
    (let ((rendered (org-chatbot--render-dialogue-tree context)))
      (should (stringp rendered))
      (should (string-match-p "#\\+TITLE:" rendered))
      (should (string-match-p "\\* Conversation Hypergraph" rendered))
      (should (string-match-p "\\*\\* \\|\\*\\*\\*" rendered)) ; Heading levels
      (should (string-match-p "Attention:" rendered))
      (should (string-match-p ":PROPERTIES:" rendered)))))

;;; Test Interactive Functions

(ert-deftest org-chatbot-test-session-start ()
  "Test chatbot session initialization."
  (let ((test-buffer-name "*Test Org Chatbot*")
        (org-chatbot-buffer-name "*Test Org Chatbot*"))
    
    (when (get-buffer test-buffer-name)
      (kill-buffer test-buffer-name))
    
    (org-chatbot-start-session "test-session")
    
    (should (get-buffer test-buffer-name))
    (should org-chatbot--current-context)
    (should (string= (org-chatbot-context-id org-chatbot--current-context)
                     "test-session"))
    
    ;; Check buffer content
    (with-current-buffer test-buffer-name
      (should (derived-mode-p 'org-mode))
      (should (string-match-p "#\\+TITLE:" (buffer-string)))
      (should (string-match-p "Welcome to the Cognitive Dialogue System" 
                              (buffer-string))))
    
    ;; Cleanup
    (kill-buffer test-buffer-name)))

;;; Test Utilities and Edge Cases

(ert-deftest org-chatbot-test-node-id-uniqueness ()
  "Test that node IDs are unique across multiple creations."
  (let ((ids (make-hash-table :test 'equal)))
    
    ;; Create multiple nodes and check ID uniqueness
    (dotimes (_ 100)
      (let* ((node (org-chatbot--create-conversation-node "test"))
             (id (org-chatbot-node-id node)))
        (should-not (gethash id ids))
        (puthash id t ids)))))

(ert-deftest org-chatbot-test-empty-message-handling ()
  "Test handling of empty or whitespace-only messages."
  (let* ((context (org-chatbot--create-context "empty-test"))
         (response1 (org-chatbot--generate-response "" context))
         (response2 (org-chatbot--generate-response "   " context)))
    
    (should (stringp response1))
    (should (stringp response2))
    (should (> (length response1) 0))
    (should (> (length response2) 0))))

(ert-deftest org-chatbot-test-long-message-handling ()
  "Test handling of very long messages."
  (let* ((context (org-chatbot--create-context "long-test"))
         (long-message (make-string 1000 ?a))
         (response (org-chatbot--generate-response long-message context)))
    
    (should (stringp response))
    (should (> (length response) 0))))

(ert-deftest org-chatbot-test-special-characters ()
  "Test handling of messages with special characters."
  (let* ((context (org-chatbot--create-context "special-test"))
         (special-message "Hello! @#$%^&*()_+ 中文 café naïve")
         (response (org-chatbot--generate-response special-message context)))
    
    (should (stringp response))
    (should (> (length response) 0))))

;;; Performance and Scalability Tests

(ert-deftest org-chatbot-test-context-size-limits ()
  "Test behavior with context approaching size limits."
  (let* ((context (org-chatbot--create-context "size-test"))
         (org-chatbot-max-context-depth 5))
    
    ;; Add many nodes to test depth management
    (dotimes (i 10)
      (org-chatbot--generate-response (format "Message %d" i) context))
    
    ;; Context should still be manageable
    (should context)
    (should (< (length (org-chatbot-context-active-nodes context)) 25))))

;;; Integration Tests

(ert-deftest org-chatbot-test-cognitive-module-integration ()
  "Test integration hooks with cognitive modules."
  ;; This is a placeholder test for the integration function
  ;; In a real implementation, this would test actual module interactions
  (should (functionp 'org-chatbot--integrate-cognitive-modules))
  
  ;; Test that function executes without error
  (should-not (condition-case err
                  (org-chatbot--integrate-cognitive-modules)
                (error err))))

;;; org-chatbot-tests.el ends here