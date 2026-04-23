'use client';

/**
 * RAPTOR OS - Main Kiosk Page
 * 
 * Layout per docs/KIOSK.md:
 * - StatusBar (top, always visible)
 * - Mesh Comms Panel (left, primary)
 * - Notes / Log Panel (right)
 * - QuickActions Strip (bottom)
 * 
 * Input Model per docs/KIOSK.md:
 * - Scrolling/wheel events: change focus WITHIN a function space
 * - Arrow Left/Right: change focus BETWEEN function spaces (wrap-around)
 * - Space bar: activate or select the focused item within a function area
 * 
 * Resolution: 640x480 fixed
 */

import { useState, useEffect, useCallback, useRef } from 'react';

// =============================================================================
// TYPES
// =============================================================================

interface SystemStatus {
  time: string;
  date: string;
  battery: number;
  batteryRuntime: string;
  cellularSignal: number | null;
  cellularConnected: boolean;
  meshNodes: number;
  meshLastActivity: string | null;
  meshUnread: number;
}

interface MeshMessage {
  id: string;
  time: string;
  sender: string;
  channel: string;
  message: string;
  direct: boolean;
}

interface Note {
  id: string;
  title: string;
  path: string;
  modified: string;
}

// Function spaces per KIOSK.md input model
type FunctionSpace = 'mesh' | 'notes' | 'actions';
type MeshSubview = 'feed' | 'compose' | 'nodes';
type NotesSubview = 'list' | 'editor';

// =============================================================================
// CONSTANTS
// =============================================================================

const MESH_UNREAD_THRESHOLD = 0;

// Navigation order: mesh -> notes -> actions -> mesh (wrap-around)
const FUNCTION_SPACES: FunctionSpace[] = ['mesh', 'notes', 'actions'];

// =============================================================================
// COMPONENTS
// =============================================================================

/**
 * StatusBar - Top bar with system indicators
 * Pulls from /api/status on mount, subscribes to status:update WebSocket
 */
function StatusBar({ status }: { status: SystemStatus }) {
  return (
    <div className="status-bar">
      <div className="status-bar-left">
        <span className="raptor-logo">RAPTOR OS</span>
        <span className="status-indicators">
          <span className={`indicator ${status.meshUnread > 0 ? 'pulse' : ''}`}>
            ●●●●○
          </span>
        </span>
      </div>
      <div className="status-bar-right">
        <span className="status-item" title="Cellular">
          [SIG] {status.cellularConnected ? `${status.cellularSignal}%` : 'OFF'}
        </span>
        <span className="status-item" title="Mesh">
          [MESH] {status.meshNodes}n
        </span>
        <span className="status-item" title="Battery">
          [BAT] {status.battery}%
        </span>
      </div>
    </div>
  );
}

/**
 * MeshCommsPanel - Left panel primary communication interface
 * Subviews: Feed, Compose, Nodes
 */
function MeshCommsPanel({
  messages,
  onSend,
  focused,
  selectedIndex,
  onSelect,
  onActivate
}: {
  messages: MeshMessage[];
  onSend: (msg: string) => void;
  focused: boolean;
  selectedIndex: number;
  onSelect: (index: number) => void;
  onActivate: (index: number) => void;
}) {
  const [subview, setSubview] = useState<MeshSubview>('feed');
  const [composeText, setComposeText] = useState('');

  const handleSend = () => {
    if (composeText.trim()) {
      onSend(composeText.trim());
      setComposeText('');
      setSubview('feed');
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (subview === 'compose') {
      if (e.key === 'Enter') {
        handleSend();
      } else if (e.key === 'Escape') {
        setSubview('feed');
      }
    }
  };

  // Handle selection - Enter key or space activates
  const handleMessageActivate = (index: number) => {
    if (subview === 'feed') {
      onActivate(index);
    }
  };

  // Scroll selected message into view
  useEffect(() => {
    if (focused && selectedIndex >= 0) {
      const selectedEl = document.querySelector(`.mesh-message.selected`);
      selectedEl?.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }, [focused, selectedIndex]);

  return (
    <div className={`panel mesh-panel ${focused ? 'focused' : ''}`}>
      <div className="panel-header">
        <span className="panel-title">MESH COMMS</span>
        <div className="panel-tabs">
          <button 
            className={`tab ${subview === 'feed' ? 'active' : ''}`}
            onClick={() => setSubview('feed')}
          >
            Feed
          </button>
          <button 
            className={`tab ${subview === 'nodes' ? 'active' : ''}`}
            onClick={() => setSubview('nodes')}
          >
            Nodes
          </button>
        </div>
      </div>
      
      <div className="panel-content">
        {subview === 'feed' && (
          <div className="mesh-feed">
            {messages.map((msg, index) => (
              <div 
                key={msg.id} 
                className={`mesh-message ${selectedIndex === index ? 'selected' : ''}`}
                onClick={() => handleMessageActivate(index)}
              >
                <span className="msg-time">{msg.time}</span>
                <span className="msg-sender">[[{msg.sender}]]</span>
                <span className="msg-channel">({msg.channel})</span>
                <div className="msg-text">{msg.message}</div>
              </div>
            ))}
            {messages.length === 0 && (
              <div className="empty-state">No messages yet</div>
            )}
          </div>
        )}
        
        {subview === 'compose' && (
          <div className="mesh-compose">
            <textarea
              value={composeText}
              onChange={(e) => setComposeText(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder="Type message..."
              autoFocus
            />
            <div className="compose-hint">Enter to send, Escape to cancel</div>
          </div>
        )}
        
        {subview === 'nodes' && (
          <div className="mesh-nodes">
            <div className="empty-state">No nodes detected</div>
          </div>
        )}
      </div>
      
      <div className="panel-footer">
        {subview === 'feed' && (
          <button 
            className="action-btn compose-btn"
            onClick={() => setSubview('compose')}
          >
            [compose]
          </button>
        )}
      </div>
    </div>
  );
}

/**
 * NotesPanel - Right panel for vault access
 * Subviews: Note list, Editor, Sync status
 */
function NotesPanel({
  notes,
  focused,
  selectedIndex,
  onSelect,
  onActivate
}: {
  notes: Note[];
  focused: boolean;
  selectedIndex: number;
  onSelect: (index: number) => void;
  onActivate: (index: number) => void;
}) {
  const [subview, setSubview] = useState<NotesSubview>('list');
  const [syncStatus, setSyncStatus] = useState<{ last: string; queue: number }>({
    last: 'never',
    queue: 0,
  });

  // Scroll selected note into view
  useEffect(() => {
    if (focused && selectedIndex >= 0) {
      const selectedEl = document.querySelector(`.note-item.selected`);
      selectedEl?.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }, [focused, selectedIndex]);

  return (
    <div className={`panel notes-panel ${focused ? 'focused' : ''}`}>
      <div className="panel-header">
        <span className="panel-title">NOTES / LOG</span>
        <div className="panel-tabs">
          <button 
            className={`tab ${subview === 'list' ? 'active' : ''}`}
            onClick={() => setSubview('list')}
          >
            List
          </button>
          <button 
            className={`tab ${subview === 'editor' ? 'active' : ''}`}
            onClick={() => setSubview('editor')}
          >
            Editor
          </button>
        </div>
      </div>
      
      <div className="panel-content">
        {subview === 'list' && (
          <div className="notes-list">
            {notes.map((note, index) => (
              <div 
                key={note.id} 
                className={`note-item ${selectedIndex === index ? 'selected' : ''}`}
                onClick={() => onActivate(index)}
              >
                <span className="note-title">{note.title}</span>
                <span className="note-modified">{note.modified}</span>
              </div>
            ))}
            {notes.length === 0 && (
              <div className="empty-state">No notes yet</div>
            )}
          </div>
        )}
        
        {subview === 'editor' && (
          <div className="notes-editor">
            <textarea placeholder="Start typing..." />
            <div className="editor-hint">Enter to save, Escape to cancel</div>
          </div>
        )}
      </div>
      
      <div className="panel-footer">
        <span className="sync-status">
          Sync: {syncStatus.last} | Queue: {syncStatus.queue}
        </span>
      </div>
    </div>
  );
}

/**
 * QuickActionsStrip - Bottom action bar
 * Actions: terminal, desktop, cellular, lora, settings
 */
function QuickActionsStrip({ 
  onAction,
  focused,
  selectedIndex,
  onSelect,
  onActivate
}: { 
  onAction: (action: string) => void;
  focused: boolean;
  selectedIndex: number;
  onSelect: (index: number) => void;
  onActivate: (index: number) => void;
}) {
  const actions = ['terminal', 'desktop', 'cellular', 'lora', 'settings'];
  
  return (
    <div className={`quick-actions ${focused ? 'focused' : ''}`}>
      {actions.map((action, index) => (
        <button 
          key={action}
          className={`action-btn ${selectedIndex === index ? 'selected' : ''}`}
          onClick={() => onAction(action)}
        >
          [{action}]
        </button>
      ))}
    </div>
  );
}

// =============================================================================
// MAIN PAGE
// =============================================================================

export default function KioskDashboard() {
  const [status, setStatus] = useState<SystemStatus>({
    time: '--:--:--',
    date: '----/--/--',
    battery: 0,
    batteryRuntime: '~0hrs',
    cellularSignal: null,
    cellularConnected: false,
    meshNodes: 0,
    meshLastActivity: null,
    meshUnread: 0,
  });
  
  const [messages, setMessages] = useState<MeshMessage[]>([]);
  const [notes, setNotes] = useState<Note[]>([]);
  
  // Focus state - tracks which function space is focused
  const [focusedSpace, setFocusedSpace] = useState<FunctionSpace>('mesh');
  
  // Index within each function space
  const [meshIndex, setMeshIndex] = useState(0);
  const [notesIndex, setNotesIndex] = useState(0);
  const [actionsIndex, setActionsIndex] = useState(0);
  
  // Refs to track item counts without re-adding to dependency arrays
  const messagesCountRef = useRef(0);
  const notesCountRef = useRef(0);

  // Update refs when data changes
  useEffect(() => {
    messagesCountRef.current = messages.length;
  }, [messages.length]);

  useEffect(() => {
    notesCountRef.current = notes.length;
  }, [notes.length]);

  // Fetch initial status
  useEffect(() => {
    const fetchStatus = async () => {
      try {
        const response = await fetch('/api/status');
        if (response.ok) {
          const data = await response.json();
          setStatus((prev) => ({ ...prev, ...data }));
        }
      } catch {
        // API not available - use defaults
      }
    };

    fetchStatus();
    const interval = setInterval(fetchStatus, 30000);
    return () => clearInterval(interval);
  }, []);

  // Fetch mesh messages
  useEffect(() => {
    const fetchMessages = async () => {
      try {
        const response = await fetch('/api/mesh/messages');
        if (response.ok) {
          const data = await response.json();
          setMessages(data.messages || []);
        }
      } catch {
        // API not available
      }
    };

    fetchMessages();
  }, []);

  // Fetch notes
  useEffect(() => {
    const fetchNotes = async () => {
      try {
        const response = await fetch('/api/notes');
        if (response.ok) {
          const data = await response.json();
          setNotes(data.notes || []);
        }
      } catch {
        // API not available
      }
    };

    fetchNotes();
  }, []);

  // Navigate between function spaces (Arrow Left/Right per KIOSK.md)
  const navigateBetweenSpaces = useCallback((direction: 'left' | 'right') => {
    const currentIndex = FUNCTION_SPACES.indexOf(focusedSpace);
    let newIndex: number;
    
    if (direction === 'left') {
      // Left arrow: mesh -> notes -> actions -> mesh (wrap backward)
      newIndex = currentIndex === 0 ? FUNCTION_SPACES.length - 1 : currentIndex - 1;
    } else {
      // Right arrow: actions -> notes -> mesh -> actions (wrap forward)
      newIndex = currentIndex === FUNCTION_SPACES.length - 1 ? 0 : currentIndex + 1;
    }
    
    setFocusedSpace(FUNCTION_SPACES[newIndex]);
    
    // Reset index in the new space to 0
    const newSpace = FUNCTION_SPACES[newIndex];
    if (newSpace === 'mesh') setMeshIndex(0);
    else if (newSpace === 'notes') setNotesIndex(0);
    else if (newSpace === 'actions') setActionsIndex(0);
  }, [focusedSpace]);

  // Navigate within current function space (Wheel events per KIOSK.md)
  const navigateWithinSpace = useCallback((delta: number) => {
    const currentSpace = focusedSpace;
    
    if (currentSpace === 'mesh') {
      // Wheel up/down scrolls through messages
      const newIndex = Math.max(0, Math.min(meshIndex + delta, messagesCountRef.current - 1));
      setMeshIndex(newIndex);
    } else if (currentSpace === 'notes') {
      // Wheel up/down scrolls through notes
      const newIndex = Math.max(0, Math.min(notesIndex + delta, notesCountRef.current - 1));
      setNotesIndex(newIndex);
    } else if (currentSpace === 'actions') {
      // Wheel up/down scrolls through action buttons (5 total)
      const newIndex = Math.max(0, Math.min(actionsIndex + delta, 4));
      setActionsIndex(newIndex);
    }
  }, [focusedSpace, meshIndex, notesIndex, actionsIndex]);

  // Activate/select the focused item (Space bar per KIOSK.md)
  const activateFocused = useCallback(() => {
    const currentSpace = focusedSpace;
    
    if (currentSpace === 'mesh') {
      // In mesh feed: select message (could open details or start compose)
      // For now, trigger compose if a message is selected
      console.log('Activate mesh item at index:', meshIndex);
    } else if (currentSpace === 'notes') {
      // In notes list: open note for editing
      console.log('Activate notes item at index:', notesIndex);
    } else if (currentSpace === 'actions') {
      // Trigger the selected action
      const actions = ['terminal', 'desktop', 'cellular', 'lora', 'settings'];
      handleQuickAction(actions[actionsIndex]);
    }
  }, [focusedSpace, meshIndex, notesIndex, actionsIndex]);

  // Mouse wheel scrolling - ANO encoder wheel scrolls within function space
  useEffect(() => {
    const handleWheel = (e: WheelEvent) => {
      // Don't intercept wheel when typing in textarea/input
      const activeElement = document.activeElement;
      if (activeElement?.tagName === 'TEXTAREA' || activeElement?.tagName === 'INPUT') {
        return;
      }
      
      e.preventDefault();
      
      // deltaY > 0 means wheel down (encoder CW) = move forward
      // deltaY < 0 means wheel up (encoder CCW) = move backward
      const delta = e.deltaY > 0 ? 1 : -1;
      navigateWithinSpace(delta);
    };

    window.addEventListener('wheel', handleWheel, { passive: false });
    return () => window.removeEventListener('wheel', handleWheel);
  }, [navigateWithinSpace]);

  // Arrow key navigation - ANO buttons for panel navigation
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Don't handle when typing in textarea
      const activeElement = document.activeElement;
      if (activeElement?.tagName === 'TEXTAREA' || activeElement?.tagName === 'INPUT') {
        return;
      }
      
      switch (e.key) {
        case 'ArrowLeft':
          e.preventDefault();
          // Left button: navigate to previous function space
          navigateBetweenSpaces('left');
          break;
        case 'ArrowRight':
          e.preventDefault();
          // Right button: navigate to next function space
          navigateBetweenSpaces('right');
          break;
        case ' ':
          e.preventDefault();
          // Space (center click): activate/select current item
          activateFocused();
          break;
        case 'ArrowUp':
        case 'ArrowDown':
          // Up/Down could be used for sub-navigation within a panel
          // For now, treat them the same as left/right for simplicity
          e.preventDefault();
          if (e.key === 'ArrowUp') {
            navigateBetweenSpaces('left');
          } else {
            navigateBetweenSpaces('right');
          }
          break;
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [navigateBetweenSpaces, activateFocused]);

  const handleSendMessage = useCallback(async (text: string) => {
    try {
      await fetch('/api/mesh/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: text }),
      });
    } catch {
      // Handle error
    }
  }, []);

  const handleQuickAction = useCallback((action: string) => {
    switch (action) {
      case 'terminal':
        // Launch terminal
        break;
      case 'desktop':
        // Launch desktop
        break;
      case 'cellular':
        // Toggle cellular
        fetch('/api/system/cellular', { method: 'POST' });
        break;
      case 'lora':
        // Toggle LoRa
        fetch('/api/system/lora', { method: 'POST' });
        break;
      case 'settings':
        // Open settings
        break;
    }
  }, []);

  // Selection handlers for panels
  const handleMeshSelect = useCallback((index: number) => {
    setMeshIndex(index);
  }, []);

  const handleNotesSelect = useCallback((index: number) => {
    setNotesIndex(index);
  }, []);

  const handleActionsSelect = useCallback((index: number) => {
    setActionsIndex(index);
  }, []);

  // Activation handlers for panels
  const handleMeshActivate = useCallback((index: number) => {
    // Could open message details or start compose
    console.log('Activate message at index:', index);
  }, []);

  const handleNotesActivate = useCallback((index: number) => {
    // Could open note in editor
    console.log('Activate note at index:', index);
  }, []);

  const handleActionsActivate = useCallback((index: number) => {
    const actions = ['terminal', 'desktop', 'cellular', 'lora', 'settings'];
    handleQuickAction(actions[index]);
  }, [handleQuickAction]);

  return (
    <div className="kiosk-dashboard">
      <StatusBar status={status} />
      
      <div className="main-content">
        <MeshCommsPanel
          messages={messages}
          onSend={handleSendMessage}
          focused={focusedSpace === 'mesh'}
          selectedIndex={meshIndex}
          onSelect={handleMeshSelect}
          onActivate={handleMeshActivate}
        />
        <NotesPanel
          notes={notes}
          focused={focusedSpace === 'notes'}
          selectedIndex={notesIndex}
          onSelect={handleNotesSelect}
          onActivate={handleNotesActivate}
        />
      </div>
      
      <QuickActionsStrip 
        onAction={handleQuickAction}
        focused={focusedSpace === 'actions'}
        selectedIndex={actionsIndex}
        onSelect={handleActionsSelect}
        onActivate={handleActionsActivate}
      />
    </div>
  );
}
