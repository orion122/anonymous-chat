<template>
    <div id="chat" class="chat">
        <button @click='logout' class='logout'>{{ this.$t('chat.leave_chat') }}</button>
        <ul class="messages" v-chat-scroll>
            <li class="message" v-for="(value, key) in messages" :key="key">{{ value }}</li>
        </ul>
        <input type="text" class='input-box_text' v-model.trim="input_message" @keyup.enter="saveMessage()" />
    </div>
</template>

<script>
    export default {
        data() {
            return {
                input_message: '',
                messages: {},
                current_session_token: localStorage.getItem('session_token')
            }
        },
        mounted: function(){
            function addMessage(messageObjectString) {
                const messageObject = JSON.parse(messageObjectString)
                const messageId = Object.keys(messageObject)[0]
                const messageLine = Object.values(messageObject)[0]

                this.$set(this.messages, messageId, messageLine)
            }

            this.$nats.subscribe(this.getChatToken(), addMessage.bind(this))
        },
        methods: {
            logout() {
                localStorage.removeItem('session_token')
                window.location.href = '/'
            },
            // getMessages() {
            //     this.$http.get(`/chats/${this.getChatToken()}/messages`
            //     ).then(response => {
            //         let userData = ''
            //         this.messages = response.body.reduce(((init, messageObject) => {
            //             userData = `${messageObject.nickname}: ${messageObject.message}`
            //             if ((messageObject.session_token === this.current_session_token) &&
            //                 (messageObject.state !== 'delivered')) {
            //                 userData += ` (${messageObject.state})`
            //             }
            //             init.push(userData)
            //             return init
            //         }), [])
            //     });
            //     Rollbar.info("JS: Get all messages")
            // },
            saveMessage() {
                if(this.input_message !== '') {
                    this.$http.post(`/chats/${this.getChatToken()}/messages`,
                        {message: this.input_message}
                    ).then(response => {});
                    this.input_message = ''
                    // Rollbar.info("JS: Save message")
                }
            },
            setStateRead() {
                this.$http.post(`/chats/${this.getChatToken()}/messages/set_state_read`);
            },
            getChatToken() {
                return window.location.href.split('/').reverse()[0]
            }
        },
        // watch: {
        //     messages: function () {
        //         this.setStateRead()
        //         this.$nats.unsubscribe()
        //     }
        // }
    }
</script>