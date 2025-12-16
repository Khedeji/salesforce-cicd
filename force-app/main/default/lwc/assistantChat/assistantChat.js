import { LightningElement, track } from 'lwc';
import getAIResponse from '@salesforce/apex/AssistantChatController.getAIResponse';
import { loadScript } from 'lightning/platformResourceLoader';
import MARKED from '@salesforce/resourceUrl/marked';

function generateSessionId() {
    return 'session-' + Math.random().toString(36).substr(2, 9) + '-' + Date.now();
}

export default class AssistantChat extends LightningElement {
    @track isOpen = false;
    @track userInput = '';
    @track messages = [];
    msgId = 0;
    markedInitialized = false;
    sessionId = generateSessionId();

   

     // Helper function to return class dynamically
    getRowClass(msg) {
        return `tw-msg-row ${msg.sender}`;
    }

    getBubbleClass(msg) {
        return `tw-msg-bubble ${msg.sender}`;
    }

    convertToMarkdown(text){
        if (window.marked) {
            return window.marked.parse(text);
        }
        return text;
    }
    toggleChat() {
        this.isOpen = !this.isOpen;
        if (this.isOpen) {
            setTimeout(() => this.scrollToBottom(), 0);
        }
    }

    handleInput(event) {
        this.userInput = event.target.value;
    }

    handleKeyDown(event) {
        if (event.key === 'Enter') {
            this.sendMessage();
        }
    }

    sendMessage() {
        const input = this.userInput.trim();
        if (!input) return;
        this.addMessage('user', input);
        this.userInput = '';
        this.fetchAIResponse(input, this.sessionId);
    }

    addMessage(sender, text) {
        const now = new Date();
        const time = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        const id = ++this.msgId;
        this.messages = [
            ...this.messages,
            {
                id,
                sender,
                text,
                time,
                isUser: sender === 'user',
                isBot: sender === 'ai'
            }
        ];
        setTimeout(() => {
            const messagesDiv = this.template.querySelector('#messages');
            if (messagesDiv) {
                messagesDiv.scrollTop = messagesDiv.scrollHeight;
            }
            // Render markdown for bot messages
            if (sender === 'ai') {
                const el = this.template.querySelector(`.tw-msg-text[data-id="${id}"]`);
                if (el) {
                    el.innerHTML = this.convertToMarkdown(text);
                }
            }
        }, 0);
    }

    async fetchAIResponse(question, sessionId) {
        this.addMessage('ai', '...');
        try {
            const answer = await getAIResponse({ question, sessionId });
            // Remove the last '...' message
            this.messages = this.messages.slice(0, -1);
            this.addMessage('ai', answer || 'Sorry, I could not understand.');
        } catch (e) {
            this.messages = this.messages.slice(0, -1);
            this.addMessage('ai', 'Error contacting AI service.');
        }
    }

    renderedCallback() {
        // Load marked.js only once
        if (!this.markedInitialized) {
            this.markedInitialized = true;
            loadScript(this, MARKED)
                .then(() => {})
                .catch(() => {});
        }
        // Render markdown for all bot messages after rerender
        this.messages.forEach(msg => {
            if (msg.isBot) {
                const el = this.template.querySelector(`.tw-msg-text[data-id="${msg.id}"]`);
                if (el) {
                    el.innerHTML = this.convertToMarkdown(msg.text);
                }
            }
        });


        // Scroll messages container to bottom every render
    const container = this.template.querySelector('[data-id="messages"]');
    if (container) {
        container.scrollTop = container.scrollHeight;
    }
    }
}