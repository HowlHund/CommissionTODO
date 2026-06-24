from mcp.server.fastmcp import FastMCP

mcp = FastMCP("todo-mcp")

COMMISSIONS = [
    {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "customer": "howlhund1",
        "type": "full_body",
        "status": "sketching",
        "notes": "likes the color red",
        "deadline": "2026-08-15T00:00:00Z"
    },
    {
        "id": "660e8400-e29b-41d4-a716-446655440001",
        "customer": "howhund2",
        "type": "chibi",
        "status": "lining",
        "notes": "reference sheet provided",
        "deadline": "2026-09-01T00:00:00Z"
    }
]


@mcp.tool()
def list_commissions() -> list:
    """List all commissions in the queue."""
    return COMMISSIONS


@mcp.tool()
def get_commission(commission_id: str) -> dict:
    """Get a single commission by its ID."""
    for commission in COMMISSIONS:
        if commission["id"] == commission_id:
            return commission
    return {"error": "not found"}


if __name__ == "__main__":
    mcp.run()
