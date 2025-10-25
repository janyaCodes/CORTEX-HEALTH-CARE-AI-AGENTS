import streamlit as st
import json
from typing import Dict, List, Optional
import pandas as pd
from datetime import datetime
from snowflake.snowpark import Session

# Initialize Snowflake session for Streamlit-in-Snowflake
@st.cache_resource
def get_session():
    """Get the active Snowflake session"""
    return Session.builder.getOrCreate()

# Page configuration
st.set_page_config(
    page_title="Medical Agent Chatbot",
    page_icon="🏥",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS for better styling
st.markdown("""
<style>
    .main-header {
        font-size: 2.5rem;
        color: #1f77b4;
        text-align: center;
        margin-bottom: 2rem;
    }
    .chat-message {
        padding: 1rem;
        border-radius: 0.5rem;
        margin: 1rem 0;
        border-left: 4px solid #1f77b4;
    }
    .user-message {
        background-color: #f0f2f6;
        border-left-color: #ff6b6b;
    }
    .agent-message {
        background-color: #e8f4fd;
        border-left-color: #1f77b4;
    }
    .stTextInput > div > div > input {
        border-radius: 20px;
    }
</style>
""", unsafe_allow_html=True)

# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = []

def call_medical_agent(question):
    """Call the Snowflake Medical Agent with a question"""
    try:
        session = get_session()
        
        # Call the medical agent using Snowpark
        query = f"""
        SELECT HOSPITAL.PUBLIC.MEDICALAGENT!ASK(
            '{question.replace("'", "''")}'
        ) AS response;
        """
        
        result_df = session.sql(query).collect()
        
        if result_df and len(result_df) > 0:
            response = result_df[0]['RESPONSE']
            if response:
                return response
            else:
                return "❌ No response received from the medical agent."
        else:
            return "❌ No response received from the medical agent."
            
    except Exception as e:
        return f"❌ Error calling medical agent: {str(e)}"

def display_chat_message(role, content):
    """Display a chat message with appropriate styling"""
    if role == "user":
        st.markdown(f"""
        <div class="chat-message user-message">
            <strong>You:</strong><br>
            {content}
        </div>
        """, unsafe_allow_html=True)
    else:
        st.markdown(f"""
        <div class="chat-message agent-message">
            <strong>🏥 Medical Agent:</strong><br>
            {content}
        </div>
        """, unsafe_allow_html=True)

# Main app
def main():
    # Header
    st.markdown('<h1 class="main-header">🏥 Medical Agent Chatbot</h1>', unsafe_allow_html=True)
    
    # Sidebar for configuration
    with st.sidebar:
        st.header("⚙️ Configuration")
        
        # Check connection status
        try:
            session = get_session()
            st.success("✅ Connected to Snowflake")
            st.info(f"Database: HOSPITAL\nSchema: PUBLIC")
        except Exception as e:
            st.error(f"❌ Connection error: {str(e)}")
        
        st.markdown("---")
        
        # Sample questions
        st.header("💡 Sample Questions")
        sample_questions = [
            "How many patients live in Dallas?",
            "Show me patient encounters with chief complaint as a rash",
            "What are the chronic conditions of patients over 60?",
            "Which patients have allergies to penicillin?",
            "Show me patients with Medicare insurance"
        ]
        
        for question in sample_questions:
            if st.button(question, key=f"sample_{question}"):
                st.session_state.user_input = question
        
        st.markdown("---")
        
        # Clear chat button
        if st.button("🗑️ Clear Chat"):
            st.session_state.messages = []
            st.rerun()
    
    # Main chat interface
    st.header("💬 Chat with Medical Agent")
    
    # Display chat history
    for message in st.session_state.messages:
        display_chat_message(message["role"], message["content"])
    
    # Chat input
    user_input = st.text_input(
        "Ask a question about patient data:",
        key="user_input",
        placeholder="e.g., How many patients live in Dallas?",
        label_visibility="collapsed"
    )
    
    # Send button
    col1, col2, col3 = st.columns([1, 1, 1])
    with col2:
        send_button = st.button("🚀 Send", type="primary", use_container_width=True)
    
    # Process user input
    if send_button and user_input:
        # Add user message to chat
        st.session_state.messages.append({"role": "user", "content": user_input})
        
        # Show loading spinner
        with st.spinner("🤖 Medical Agent is thinking..."):
            # Get response from medical agent
            response = call_medical_agent(user_input)
        
        # Add agent response to chat
        st.session_state.messages.append({"role": "assistant", "content": response})
        
        # Clear input and rerun
        st.session_state.user_input = ""
        st.rerun()
    
    # Footer
    st.markdown("---")
    st.markdown(
        """
        <div style='text-align: center; color: #666; font-size: 0.8rem;'>
            🏥 Medical Agent Chatbot | Powered by Snowflake Cortex AI
        </div>
        """, 
        unsafe_allow_html=True
    )

if __name__ == "__main__":
    main()
